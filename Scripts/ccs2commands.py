#!/usr/bin/env python3
"""
ccs_convert.py

Runs split_ccs preprocessing over the input file, then converts
hex bracket blocks to named command calls.

Usage:
  python ccs_convert.py stdext.ccs input.ccs output.ccs [--strict] [--flags flags.ccs]
"""

import argparse
import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Dict, Any

def split_ccs_text(text: str) -> str:
    """Pre-process CCS source: split compound hex/brace lines one per line."""
        # text is already provided as a parameter

    # Preserve block comments (/* ... */) with placeholders
    block_pattern = re.compile(r"/\*.*?\*/", re.DOTALL)
    blocks = []
    def _block_repl(m):
        blocks.append(m.group(0))
        return f"__BLOCK_COMMENT_{len(blocks)-1}__"
    text = block_pattern.sub(_block_repl, text)

    def is_import_line(s):
        return bool(re.match(r'^\s*import\b', s))
    def is_command_line(s):
        return bool(re.match(r'^\s*command\b', s))

    def is_command_signature_block(lines, idx):
        if idx + 2 < len(lines):
            a = lines[idx].strip()
            b = lines[idx+1].strip()
            c = lines[idx+2].strip()
            if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$', a) and re.match(r'^[A-Za-z_][A-Za-z0-9_]*(\([^\)]*\))?$', b) and c.startswith('"') and c.endswith('"'):
                return True
        return False

    def tokenize_line(line):
        tokens = []
        i = 0
        n = len(line)
        while i < n:
            c = line[i]
            if c == '/' and i+1 < n and line[i+1] == '/':
                tokens.append(line[i:])
                break
            if c.isspace():
                i += 1
                continue
            if line.startswith("__BLOCK_COMMENT_", i):
                m = re.match(r"__BLOCK_COMMENT_(\d+)__", line[i:])
                if m:
                    tokens.append(m.group(0))
                    i += len(m.group(0))
                    continue
            if c == '"':
                j = i + 1
                while j < n:
                    if line[j] == '\\':
                        j += 2
                        continue
                    if line[j] == '"':
                        break
                    j += 1
                tokens.append(line[i:j+1] if j < n else line[i:])
                i = j + 1
                continue
            if c == '[':
                j = i + 1
                depth = 1
                while j < n and depth > 0:
                    if line[j] == '[':
                        depth += 1
                    elif line[j] == ']':
                        depth -= 1
                    j += 1
                tokens.append(line[i:j])
                i = j
                continue
            if c == '{':
                j = i + 1
                depth = 1
                while j < n and depth > 0:
                    if line[j] == '{':
                        depth += 1
                    elif line[j] == '}':
                        depth -= 1
                    j += 1
                tokens.append(line[i:j])
                i = j
                continue
            j = i
            paren_depth = 0
            while j < n:
                ch = line[j]
                if ch == '(':
                    paren_depth += 1
                    j += 1
                elif ch == ')':
                    paren_depth -= 1
                    j += 1
                    if paren_depth <= 0:
                        break
                elif ch == '"' and paren_depth > 0:
                    # quoted string inside parens — consume it whole
                    j += 1
                    while j < n:
                        if line[j] == '\\': j += 2; continue
                        if line[j] == '"': j += 1; break
                        j += 1
                elif ch.isspace() and paren_depth == 0:
                    break
                elif ch in '"[{/' and paren_depth == 0:
                    break
                else:
                    j += 1
            tokens.append(line[i:j])
            i = j
        return tokens

    def split_consecutive_brackets_and_braces(text):
        parts = []
        i = 0
        n = len(text)
        while i < n:
            c = text[i]
            if c == '"':
                j = i + 1
                while j < n:
                    if text[j] == '\\':
                        j += 2
                        continue
                    if text[j] == '"':
                        break
                    j += 1
                parts.append(text[i:j+1] if j < n else text[i:])
                i = j + 1
                continue
            if c in '[{':
                open_ch = c
                close_ch = ']' if c == '[' else '}'
                j = i + 1
                depth = 1
                while j < n and depth > 0:
                    if text[j] == open_ch:
                        depth += 1
                    elif text[j] == close_ch:
                        depth -= 1
                    j += 1
                parts.append(text[i:j])
                i = j
                continue
            j = i
            while j < n and text[j] not in '"[{':
                j += 1
            if i < j:
                segment = text[i:j]
                if segment:
                    parts.append(segment)
            i = j
        return parts

    def unwrap_brace_if_simple(s):
        # s is like "{...}" or inner string without braces
        inner = s[1:-1].strip() if s.startswith('{') and s.endswith('}') else s.strip()
        # Allow names, dotted names, underscores and optional function-like parentheses with anything inside.
        if re.match(r'^[A-Za-z_][A-Za-z0-9_\.]*\s*(\([^\)]*\))?$', inner):
            return inner
        return None

    def split_token_to_outputs(tok):
        tok = tok.strip()
        if not tok:
            return []
        if tok.startswith("__BLOCK_COMMENT_"):
            return [tok]
        if tok.startswith('"') and tok.endswith('"'):
            return [tok]
        if tok.startswith('[') and tok.endswith(']'):
            return [tok]
        if tok.startswith('{') and tok.endswith('}'):
            u = unwrap_brace_if_simple(tok)
            return [u] if u is not None else [tok]
        parts = []
        i = 0
        n = len(tok)
        while i < n:
            c = tok[i]
            if c == '"':
                j = i+1
                while j < n:
                    if tok[j] == '\\':
                        j += 2
                        continue
                    if tok[j] == '"':
                        break
                    j += 1
                parts.append(tok[i:j+1] if j < n else tok[i:])
                i = j+1
            elif c == '[':
                j = i+1
                depth = 1
                while j < n and depth > 0:
                    if tok[j] == '[':
                        depth += 1
                    elif tok[j] == ']':
                        depth -= 1
                    j += 1
                parts.append(tok[i:j])
                i = j
            elif c == '{':
                j = i+1
                depth = 1
                while j < n and depth > 0:
                    if tok[j] == '{':
                        depth += 1
                    elif tok[j] == '}':
                        depth -= 1
                    j += 1
                piece = tok[i:j]
                u = unwrap_brace_if_simple(piece)
                parts.append(u if u is not None else piece)
                i = j
            else:
                j = i
                while j < n and tok[j] not in '"[{':
                    j += 1
                segment = tok[i:j].strip()
                if segment:
                    parts.append(segment)
                i = j
        return parts

    # New helper: If a quoted string ends with a hex byte pattern like [03] (optionally repeated),
    # split the quoted string into the quoted text (without the trailing bracketed bytes)
    # followed by separate quoted bracket tokens for each trailing [..] hex byte.
    _trailing_hex_bytes_re = re.compile(r'(.*?)(\[(?:[0-9A-Fa-f]{2})\])+$')

    def split_trailing_hex_bytes_from_quoted(qtok):
        # qtok includes surrounding quotes
        if not (qtok.startswith('"') and qtok.endswith('"')):
            return [qtok]
        inner = qtok[1:-1]
        m = _trailing_hex_bytes_re.fullmatch(inner)
        if not m:
            return [qtok]
        text_part = m.group(1)
        # find all bracket groups at end
        bracket_groups = re.findall(r'\[(?:[0-9A-Fa-f]{2})\]', inner[len(text_part):])
        outputs = []
        # original text part, only add if non-empty; keep as quoted string
        if text_part:
            outputs.append('"' + text_part + '"')
        for bg in bracket_groups:
            outputs.append('"' + bg + '"')
        return outputs


    def _is_pause(s):
        """True if s is an unwrapped pause(N) call or {pause(N)}."""
        return bool(re.match(r'^\{?pause\(\d+\)\}?$', s))
    
    def _rebuild_inner_parts(merged_parts):
        """Convert merged inner segments into output parts.

        - Leading [hex] brackets (before any text): split out as separate quoted items.
        - Mid-text [hex] brackets (after text has started): keep embedded as {hex}
          so dehex converts them inline; collect their hex values for a trailing comment.
        - {pause(N)} followed by two-space text: split point.
        - {pause(N)} followed by single-space/glued text: keep embedded as {pause(N)}.
        - {pause(N)} at end / before bracket: stash as separate trailing part.
        """
        result = []
        acc_text   = None   # plain text for current quoted segment
        acc_pause  = None   # pending pause(N) — not yet committed

        def flush_text():
            if acc_text is not None:
                result.append(f'"{acc_text}"')

        def flush_pause():
            if acc_pause is not None:
                result.append(acc_pause)

        for idx, ip in enumerate(merged_parts):
            if ip is None: continue
            if ip.startswith('{') and ip.endswith('}'):
                inner_s = ip[1:-1].strip()
                u = re.match(r'^[A-Za-z_][A-Za-z0-9_.]*\s*(\([^)]*\))?$', inner_s)
                unwrapped = inner_s if u else None

                if _is_pause(ip):
                    next_ip = merged_parts[idx+1] if idx+1 < len(merged_parts) else None
                    if next_ip is not None and not next_ip.startswith('[') and not next_ip.startswith('{'):
                        if next_ip.startswith('  '):
                            # Two-space: split point — stash pause
                            if acc_pause is not None and acc_text is None:
                                flush_pause(); acc_pause = None
                            acc_pause = unwrapped or ip
                        else:
                            # Single-space or glued: embed as literal {pause(N)}
                            if acc_text is None: acc_text = ip
                            else: acc_text += ip
                    else:
                        # End of sequence or followed by bracket: stash as trailing part
                        if acc_pause is not None and acc_text is None:
                            flush_pause(); acc_pause = None
                        acc_pause = unwrapped or ip
                else:
                    # Non-pause brace: embed if followed by plain text (inline display),
                    # UNLESS it's a flow/control command that should always stand alone.
                    # Flow braces: control-flow ops that are not inline display values.
                    _SPLIT_BRACES = {
                        'window_open', 'window_closeall', 'rtoarg', 'ctoarg',
                        'promptw', 'wait_movement', 'restore_camera', 'party_freeze',
                        'party_unfreeze', 'music_resume', 'music_stop', 'sound',
                    }
                    _brace_base = inner_s.split('(')[0].strip()
                    _is_split_brace = _brace_base in _SPLIT_BRACES
                    next_ip = merged_parts[idx+1] if idx+1 < len(merged_parts) else None
                    # A whitespace-only next segment does not count as "plain text"
                    next_is_plain = (next_ip is not None
                        and not next_ip.startswith('[') and not next_ip.startswith('{')
                        and next_ip.strip() != '')
                    if next_is_plain and not _is_split_brace:
                        # Embed brace inline — keep as {cmd} in text string
                        if acc_text is None: acc_text = ip
                        else: acc_text += ip
                    else:
                        # Flow brace or no following text: flush and emit standalone
                        flush_text(); flush_pause()
                        acc_text = None; acc_pause = None
                        result.append(unwrapped if unwrapped else ip)

            elif not ip.startswith('[') and not ip.startswith('{'):
                # Pure-whitespace segments between commands are separators, not text content.
                # EXCEPTION: whitespace before a [bracket] that will become an inline command
                # (e.g. '  ' before '[1C 08 01]') is a text-indent prefix — keep it.
                if ip.strip() == '':
                    next_ip = merged_parts[idx+1] if idx+1 < len(merged_parts) else None
                    next_is_bracket = (next_ip is not None and next_ip.startswith('['))
                    if next_is_bracket and acc_text is None:
                        # Whitespace-before-bracket: treat as text prefix for the next segment
                        acc_text = ip
                    # else: discard — pure separator between commands
                elif ip.startswith('  ') and acc_pause is not None:
                    # Two-space continuation: close prev segment
                    flush_text(); flush_pause()
                    acc_text = None; acc_pause = None
                    acc_text = ip
                else:
                    if acc_text is None: acc_text = ip
                    else: acc_text += ip
            else:
                # [hex] bracket
                # Single bytes in [AB]-[CF] are character codes — keep embedded in text
                single_byte_m = re.match(r'^\[([0-9A-Fa-f]{2})\]$', ip)
                is_char_code = bool(single_byte_m and
                    0x50 <= int(single_byte_m.group(1), 16) <= 0xCF)
                if acc_text is not None or is_char_code:
                    # Mid-text or character code: keep embedded
                    if acc_text is None: acc_text = ip
                    else: acc_text += ip
                else:
                    # Leading bracket: check for load_str pattern [19 02] + plain text
                    next_ip = merged_parts[idx+1] if idx+1 < len(merged_parts) else None
                    is_load_str_bracket = (ip == '[19 02]')
                    if is_load_str_bracket and next_ip is not None and not next_ip.startswith('[') and not next_ip.startswith('{'):
                        # Consume the following text as load_str argument.
                        # Emit as a quoted token "[19 02]text" so that process_text's
                        # opening_quote_before path converts it to load_str("text").
                        flush_pause(); acc_pause = None
                        result.append('"[19 02]' + next_ip + '"')
                        # Mark next part consumed
                        merged_parts[idx+1] = None
                    else:
                        # Regular leading bracket: split out as separate item
                        flush_pause()
                        acc_pause = None
                        result.append('"' + ip + '"')

        # Flush remainders
        flush_text(); flush_pause()
        return result

    lines = text.splitlines()
    out_lines = []
    i = 0
    while i < len(lines):
    # Fix: treat standalone line comments as top-level (no leading tab).
    # Replace the earlier handling of blank/quoted-only lines and the main loop's
    # comment detection with this small change.

    # --- Change to insert near the top of the main processing loop, replacing the
    #     existing early checks that handle blank lines / import / command / signature ---
        line = lines[i]
        if not line.strip():
            out_lines.append("")
            i += 1
            continue

        # NEW: standalone line comment (starts with optional whitespace then //) -> keep as-is
        if re.match(r'^\s*//', line):
            out_lines.append(line.rstrip())
            i += 1
            continue

        if is_import_line(line):
            out_lines.append(line.strip())
            i += 1
            continue

        if is_command_line(line):
            out_lines.append(line.strip())
            i += 1
            continue

        if is_command_signature_block(lines, i):
            out_lines.append(lines[i].strip())
            out_lines.append(lines[i+1].strip())
            out_lines.append(lines[i+2].strip())
            i += 3
            continue

        stripped = line.strip()
        if stripped.endswith(":") and len(stripped.split()) == 1:
            out_lines.append(stripped)
            i += 1
            continue

        # Preserve if/else/{/} control-flow lines and their inner content as-is.
        # Track brace depth: when inside a block, preserve original indentation.
        if re.match(r'^(if|else)(\s|$)', stripped) or stripped in ('{', '}'):
            leading = re.match(r'^(\s*)', line).group(1)
            if not leading: leading = '\t'
            out_lines.append(leading + stripped)
            # If this line opens a block, consume all lines until matching }
            if stripped.endswith('{'):
                depth = 1
                i += 1
                while i < len(lines) and depth > 0:
                    inner_line = lines[i]
                    inner_stripped = inner_line.strip()
                    if inner_stripped.endswith('{'):
                        depth += 1
                    elif inner_stripped == '}':
                        depth -= 1
                    out_lines.append(inner_line.rstrip())
                    i += 1
                continue
            i += 1
            continue

        toks = tokenize_line(line)

        if len(toks) == 1 and toks[0].strip().startswith('"') and toks[0].strip().endswith('"'):
            # If this quoted token is exactly a single brace-group inside quotes, unwrap it.
            qt = toks[0].strip()
            if qt.startswith('"') and qt.endswith('"'):
                inner = qt[1:-1]
                u = None
                if inner.startswith('{') and inner.endswith('}'):
                    u = unwrap_brace_if_simple(inner)
                if u:
                    out_lines.append("\t" + u)
                    i += 1
                    continue
            # Try splitting trailing single-byte hex brackets first
            split_qs = split_trailing_hex_bytes_from_quoted(qt)
            if len(split_qs) > 1:
                first = split_qs[0]
                rest = " ".join(split_qs[1:])
                out_lines.append("\t" + first + " " + rest)
                i += 1
                continue
            # Try splitting consecutive [hex]{brace} tokens inside the quoted string
            consec_pat = re.compile(r'(?:\{[^\}]*\}|\[[^\]]*\])(?:\s*(?:\{[^\}]*\}|\[[^\]]*\]))+')
            if consec_pat.search(inner):
                inner_parts = split_consecutive_brackets_and_braces(inner)
                merged = []
                for idx_ip, ip in enumerate(inner_parts):
                    if ip.startswith('[') and ip.endswith(']') and merged:
                        prev = merged[-1]
                        prev_is_plain = not re.search(r'[\[\]{}]', prev)
                        if prev_is_plain and (prev + ip) in inner and not prev[-1].isspace():
                            pos = inner.find(prev + ip)
                            if not (pos > 0 and inner[pos-1] == ']'):
                                merged[-1] = prev + ip
                                continue
                    if merged and not ip.startswith('[') and not ip.startswith('{'):
                        prev = merged[-1]
                        next_ip = inner_parts[idx_ip+1] if idx_ip+1 < len(inner_parts) else None
                        if (prev.endswith(']') and (prev+ip) in inner
                                and next_ip is not None
                                and next_ip.startswith('[') and next_ip.endswith(']')
                                and ip.strip() != ''):  # don't merge whitespace-only separators
                            merged[-1] = prev + ip
                            continue
                    merged.append(ip)
                for rp in _rebuild_inner_parts(merged):
                    if rp.startswith('"') and rp.endswith('"'):
                        out_lines.append('\t' + rp)
                    else:
                        out_lines.append('\t' + rp)
                i += 1
                continue
            # No special split — emit as-is
            out_lines.append("\t" + qt)
            i += 1
            continue

        comment_idx = None
        for idx, t in enumerate(toks):
            if t.strip().startswith("//"):
                comment_idx = idx
                break

        if comment_idx is not None:
            code_tokens = toks[:comment_idx]
            comment_tok = toks[comment_idx].strip()
            joined_code = " ".join(code_tokens).strip()
            single_call_match = re.match(r'^[A-Za-z_][A-Za-z0-9_]*\s*\(.*\)$', joined_code)
            if single_call_match:
                out_lines.append("\t" + joined_code + "\t" + comment_tok)
                i += 1
                continue

            parts = split_consecutive_brackets_and_braces(joined_code)

            if not parts:
                out_lines.append("\t" + comment_tok)
            else:
                for pi, p in enumerate(parts):
                    if p.startswith("__BLOCK_COMMENT_"):
                        m = re.match(r"__BLOCK_COMMENT_(\d+)__", p)
                        if m:
                            blk = int(m.group(1))
                            for bl in blocks[blk].splitlines():
                                out_lines.append(bl.rstrip())
                        continue
                    # If p is quoted and contains a single brace-group like "{...}", try to unwrap it.
                    if p.startswith('"') and p.endswith('"'):
                        inner = p[1:-1]
                        if inner.startswith('{') and inner.endswith('}'):
                            u = unwrap_brace_if_simple(inner)
                            if u:
                                out = '\t' + u
                            else:
                                out = '\t' + p
                        else:
                            out = '\t' + p
                    elif p.startswith('{') and p.endswith('}'):
                        u = unwrap_brace_if_simple(p)
                        out = '\t' + (u if u is not None else p)
                    elif p.startswith('[') and p.endswith(']'):
                        out = '\t"' + p + '"'
                    else:
                        out = '\t' + p
                    if pi == len(parts) - 1:
                        out_lines.append(out + "\t" + comment_tok)
                    else:
                        out_lines.append(out)
            i += 1
            continue

        parts = []
        for tok in toks:
            if not tok:
                continue
            if tok.startswith("__BLOCK_COMMENT_"):
                m = re.match(r"__BLOCK_COMMENT_(\d+)__", tok)
                if m:
                    blk = int(m.group(1))
                    for bl in blocks[blk].splitlines():
                        out_lines.append(bl.rstrip())
                continue

            if tok.startswith('"') and tok.endswith('"') and len(tok) >= 2:
                inner = tok[1:-1]
                # If inner is exactly a single brace-group, try to unwrap it.
                if inner.startswith('{') and inner.endswith('}'):
                    u = unwrap_brace_if_simple(inner)
                    if u:
                        parts.append(u)
                        continue
                consec_pattern = re.compile(r'(?:\{[^\}]*\}|\[[^\]]*\])(?:\s*(?:\{[^\}]*\}|\[[^\]]*\]))+')
                starts_bracket_then_text = bool(re.match(r'^\[', inner)) and bool(
                    re.search(r'\]@', inner))
                starts_brace_then_text = bool(re.match(r'^\{[^}]+\}@', inner))
                if consec_pattern.search(inner) or starts_bracket_then_text or starts_brace_then_text:
                    inner_parts = split_consecutive_brackets_and_braces(inner)
                    # Merge any [..] segment back onto the preceding segment when that
                    # preceding segment ends with a plain character (not ] or }).
                    # This prevents e.g. "@([1C 02 00]" from being split into "@(" + "[1C 02 00]".
                    merged_parts = []
                    for idx_ip, ip in enumerate(inner_parts):
                        if ip.startswith('[') and ip.endswith(']') and merged_parts:
                            prev = merged_parts[-1]
                            prev_is_plain = not re.search(r'[\[\]{}]', prev)
                            adjacent = (prev + ip) in inner
                            if prev_is_plain and adjacent and not prev[-1].isspace():
                                pos = inner.find(prev + ip)
                                preceded_by_bracket = pos > 0 and inner[pos - 1] == ']'
                                if not preceded_by_bracket:
                                    merged_parts[-1] = prev + ip
                                    continue
                        # Plain text directly glued after a ] and before another [?
                        # e.g. "[1C 02 00]'s[...]" — absorb "'s" into the preceding segment.
                        if merged_parts and not ip.startswith('[') and not ip.startswith('{'):
                            prev = merged_parts[-1]
                            next_ip = inner_parts[idx_ip + 1] if idx_ip + 1 < len(inner_parts) else None
                            if (prev.endswith(']') and (prev + ip) in inner
                                    and next_ip is not None
                                    and next_ip.startswith('[') and next_ip.endswith(']')
                                    and ip.strip() != ''):  # don't merge whitespace-only separators
                                merged_parts[-1] = prev + ip
                                continue
                        merged_parts.append(ip)
                    parts.extend(_rebuild_inner_parts(merged_parts))
                    continue
                else:
                    inner_parts = split_consecutive_brackets_and_braces(inner)
                    # Split if: ends with pause(N), OR contains pause(N) before two-space text
                    needs_split = False
                    if len(inner_parts) >= 2 and _is_pause(inner_parts[-1]):
                        needs_split = True
                    else:
                        for ki, kp in enumerate(inner_parts):
                            if (_is_pause(kp) and ki+1 < len(inner_parts)
                                    and not inner_parts[ki+1].startswith('[')
                                    and not inner_parts[ki+1].startswith('{')
                                    and inner_parts[ki+1].startswith('  ')):
                                needs_split = True; break
                    # Also split (via _rebuild_inner_parts) if inner contains
                    # char-code brackets [AB]-[CF] — they must stay embedded.
                    has_char_code = any(
                        re.match(r'^\[([0-9A-Fa-f]{2})\]$', kp) and
                        0x50 <= int(re.match(r'^\[([0-9A-Fa-f]{2})\]$', kp).group(1), 16) <= 0xCF
                        for kp in inner_parts)
                    if needs_split or has_char_code:
                        parts.extend(_rebuild_inner_parts(inner_parts))
                        continue
                    # Split trailing single-byte hex brackets
                    split_qs = split_trailing_hex_bytes_from_quoted(tok)
                    if len(split_qs) == 1:
                        parts.append(tok)
                    else:
                        first = split_qs[0]
                        rest = " ".join(split_qs[1:])
                        parts.append(first + " " + rest)
                    continue

            if tok.startswith('{') and '}{' in tok:
                brace_parts = []
                idx2 = 0
                while idx2 < len(tok):
                    if tok[idx2] == '{':
                        j = idx2 + 1
                        depth = 1
                        while j < len(tok) and depth > 0:
                            if tok[j] == '{':
                                depth += 1
                            elif tok[j] == '}':
                                depth -= 1
                            j += 1
                        piece = tok[idx2:j]
                        u = unwrap_brace_if_simple(piece)
                        brace_parts.append(u if u is not None else piece)
                        idx2 = j
                    else:
                        idx2 += 1
                parts.extend(brace_parts)
                continue

            # If tok is a paren-balanced call containing quoted strings,
            # emit it as-is — e.g. two_choice_menu("x", ref, "y", ref)
            if (re.match(r'^[A-Za-z_][A-Za-z0-9_.]*\(', tok)
                    and tok.endswith(')')
                    and '"' in tok):
                parts.append(tok)
                continue
            split_parts = split_consecutive_brackets_and_braces(tok)
            for sp in split_parts:
                if sp.startswith('{') and sp.endswith('}'):
                    u = unwrap_brace_if_simple(sp)
                    parts.append(u if u is not None else sp)
                else:
                    parts.append(sp)

        j = 0
        while j < len(parts):
            p = parts[j]

            # A quoted string may be followed by call(...) + more quoted text:
            # keep the whole run on one line, e.g. "@(" call(...) " used..." next
            if p.startswith('"') and p.endswith('"') and j + 1 < len(parts):
                inner = p[1:-1]
                nxt = parts[j+1]
                # call(...) between quoted strings — only when arg is a label ref
                # (contains '.' or 'l_0x'), not plain commands like pause(20)
                if re.match(r'^[A-Za-z_][A-Za-z0-9_.]*\(', nxt) and re.search(r'[.(](?:data_|l_0x|[A-Za-z_][A-Za-z0-9_]*\.)', nxt):
                    # Don't join if the first string ends with ']' — it has a trailing
                    # hex bracket (mid-text command) that process_text needs to split out.
                    _has_trailing_bracket = inner.endswith(']') and '[' in inner
                    # peek ahead: is there a quoted string after the call?
                    k = j + 2
                    if not _has_trailing_bracket and k < len(parts) and parts[k].startswith('"') and parts[k].endswith('"'):
                        # accumulate: quoted call quoted [keyword...]
                        run = [p, nxt, parts[k]]
                        k += 1
                        while k < len(parts) and re.match(
                                r'^(next|linebreak|newline|swap|wait|promptw|end|\.|@)$', parts[k]):
                            run.append(parts[k])
                            k += 1
                        out_lines.append('\t' + ' '.join(run))
                        j = k
                        continue
                # quoted + pause(N) + linebreak-keyword → all on one line
                if re.match(r'^pause\(\d+\)$', nxt) and j + 2 < len(parts) \
                  and re.match(r'^(next|linebreak|newline|swap|wait|promptw|end|\.|@)$', parts[j+2]):
                    out_lines.append('\t' + p + ' ' + nxt + ' ' + parts[j+2])
                    j += 3
                    continue
                # quoted + pause(N) + two-space quoted string (text continuation)
                # → join pause onto first quoted line only
                if re.match(r'^pause\(\d+\)$', nxt) and j + 2 < len(parts) \
                  and parts[j+2].startswith('"  '):
                    out_lines.append('\t' + p + ' ' + nxt)
                    j += 2
                    continue
                # plain trailing keyword
                # Allow join even if inner ends with ']' when it's a char-code [AB]-[CF]
                # OR when the trailing bracket is multi-byte (inline command, not a split point)
                ends_with_char_code = bool(
                    inner and re.search(r'\[([A-Ca-c][0-9A-Fa-f]|[A-Fa-f][Bb-fF])\]$', inner)
                    and re.search(r'\[([0-9A-Fa-f]{2})\]$', inner)
                    and 0x50 <= int(re.search(r'\[([0-9A-Fa-f]{2})\]$', inner).group(1), 16) <= 0xCF
                )
                _trailing_bracket_m = re.search(r'\[([^\]]+)\]$', inner) if inner else None
                ends_with_multibyte_bracket = bool(
                    _trailing_bracket_m
                    and len(_trailing_bracket_m.group(1).split()) > 1
                )
                if inner and (inner[-1] not in (']', '}') or ends_with_char_code or ends_with_multibyte_bracket) \
                  and re.match(r'^(next|linebreak|newline|swap|wait|promptw|end|\.|@)$', nxt):
                    combined = '\t' + p + ' ' + nxt
                    out_lines.append(combined)
                    j += 2
                    continue

            # fallback handlers
            if p.startswith('[') and p.endswith(']'):
                out_lines.append('\t"' + p + '"')
            elif p.startswith('"') and p.endswith('"'):
                out_lines.append('\t' + p)
            elif p.startswith('{') and p.endswith('}'):
                inner = p[1:-1].strip()
                if re.match(r'^[A-Za-z0-9_\.]+$', inner):
                    out_lines.append('\t' + inner)
                else:
                    out_lines.append('\t' + p)
            else:
                out_lines.append('\t' + p)
            j += 1

        i += 1

    final = []
    k = 0
    while k < len(out_lines):
        cur = out_lines[k]
        if cur.startswith("\t") and re.search(r',$', cur) and k + 1 < len(out_lines):
            nxt = out_lines[k+1]
            if nxt.startswith("\t") and re.match(r'^\t[lL]_[0-9a-fxA-F_]+(:)?$', nxt):
                final.append(cur + " " + nxt.lstrip())
                k += 2
                continue
        if cur.startswith("\t") and '(' in cur and ')' not in cur and k + 1 < len(out_lines):
            nxt = out_lines[k+1]
            if nxt.startswith("\t") and re.match(r'^\t[lL]_[0-9a-fxA-F_]+', nxt):
                final.append(cur.rstrip() + " " + nxt.lstrip())
                k += 2
                continue
        final.append(cur)
        k += 1

    result = "\n".join(final)
    for idx, blk in enumerate(blocks):
        result = result.replace(f"__BLOCK_COMMENT_{idx}__", blk)


    return result


# Regexes
CMD_DEF_RE = re.compile(r'^command\s+([A-Za-z_]\w*)\s*(?:\(([^)]*)\))?\s*(?:(?:([A-Za-z_]\w*)\s+)?(?:"([^"]+)")?)\s*(.*)?$')
# capture optional surrounding quote char as group(1), inner content as group(2)
HEX_BLOCK_RE = re.compile(r'("?)\[(.*?)\]\1')
LABEL_EMBED_RE = re.compile(r'\{e\(([^)]+)\)\}')
SINGLE_HEX_RE = re.compile(r'\b[0-9A-Fa-f]{2}\b')

def parse_cmd_def_line(line: str):
    m = CMD_DEF_RE.match(line.strip())
    if not m:
        return None
    name = m.group(1)
    params_raw = m.group(2) or ''
    params = [p.strip() for p in params_raw.split(',')] if params_raw.strip() else []
    maybe_alias = m.group(3)
    pattern = m.group(4)
    extra = (m.group(5) or '').strip()

    if pattern is not None:
        pattern = pattern.strip()
        if pattern.startswith('"') and pattern.endswith('"'):
            pattern = pattern[1:-1]

    if name.startswith('"') and name.endswith('"'):
        name = name[1:-1]
    if extra and extra.startswith('"') and extra.endswith('"'):
        extra = extra[1:-1]

    if not pattern and maybe_alias and not extra:
        return (name, params, None, maybe_alias)
    return (name, params, pattern, extra)

def load_command_file(path: str):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()

    fragments = []
    for m in re.finditer(r'/\*(.*?)\*/', text, flags=re.DOTALL):
        fragments.append(m.group(1))
    for m in re.finditer(r'//(.*)$', text, flags=re.MULTILINE):
        fragments.append(m.group(1))
    fragments.append(text)

    parsed = []
    seen = set()

    # list of command names to ignore (exact)
    IGNORE_NAMES = {
        'eob', 'linebreak', 'newline', 'inc', 'clearline', 'wait', 'prompt',
        'boost_exp', 'open_wallet',
    }

    # list of specific pattern strings to ignore (normalized, without surrounding quotes)
    IGNORE_PATTERNS = {
        '[02]', '02',
        '[00]', '00',
        '[01]', '01',
        '[04 {short f}]', '04 {short f}',
        '[05 {short f}]', '05 {short f}',
        '[07 {short f}]', '07 {short f}',
        '[08 {long target}]', '08 {long target}',
        '[0A {long target}]', '0A {long target}',
        '[0B {byte n}]', '0B {byte n}',
        '[0C {byte n}]', '0C {byte n}',
        '[0D 00]', '0D 00',
        '[0D 01]', '0D 01',
        '[0E {byte n}]', '0E {byte n}',
        '[0F]', '0F',
        '[10 {byte len}]', '10 {byte len}',
        '[12]', '12',
        '[13]', '13',
        '[14]', '14',
    }

    for frag in fragments:
        for ln in frag.splitlines():
            ln2 = ln.strip()
            if not ln2:
                continue
            if ln2.startswith('//'):
                ln2 = ln2[2:].strip()
            if ln2.startswith('/*'):
                ln2 = ln2[2:].strip()
            if ln2.endswith('*/'):
                ln2 = ln2[:-2].strip()
            if ln2.startswith('*'):
                ln2 = ln2[1:].strip()
            if not ln2:
                continue
            p = parse_cmd_def_line(ln2)
            if not p:
                continue

            # Ignore specific command definitions
            name, params, pattern, extra = p
            pat_norm = (pattern or "").strip().strip('"')
            extra_norm = (extra or "").strip().strip('"')

            # ignore by exact name or by pattern/extra membership
            if name in IGNORE_NAMES or pat_norm in IGNORE_PATTERNS or extra_norm in IGNORE_PATTERNS:
                continue

            key = (p[0], p[2])
            if key in seen:
                continue
            seen.add(key)
            parsed.append(p)
    return parsed

def tokenize_pattern(pattern: str):
    if pattern is None:
        return []
    s = pattern.strip()
    if s.startswith('[') and s.endswith(']'):
        s = s[1:-1].strip()
    tokens = []
    i = 0
    while i < len(s):
        if s[i].isspace():
            i += 1; continue
        if s[i] == '{':
            j = s.find('}', i)
            if j == -1:
                raise ValueError("Unclosed brace in pattern: " + pattern)
            tokens.append(('arg', s[i+1:j].strip()))
            i = j+1
            continue
        m = SINGLE_HEX_RE.match(s, i)
        if m:
            tokens.append(('hex', m.group(0).upper()))
            i = m.end()
            continue
        j = i
        while j < len(s) and not s[j].isspace():
            j += 1
        tok = s[i:j].strip()
        if re.fullmatch(r'[0-9A-Fa-f]+', tok):
            for k in range(0, len(tok), 2):
                byte = tok[k:k+2]
                if len(byte)==2:
                    tokens.append(('hex', byte.upper()))
        else:
            tokens.append(('word', tok))
        i = j
    return tokens

def build_patterns(cmd_defs):
    patterns = []
    for name, params, pattern, extra in cmd_defs:
        tokens = tokenize_pattern(pattern) if pattern else []
        patterns.append({
            'name': name,
            'params': params,
            'pattern': pattern,
            'extra': extra,
            'tokens': tokens
        })
    patterns.sort(key=lambda p: (-sum(1 for t in p['tokens'] if t[0]=='hex'), -len(p['tokens'])))
    return patterns

def bytes_from_block_text(inner: str) -> Tuple[List[int], List[Tuple[int,str]]]:
    parts = re.split(r'(\{e\([^)]+\)\})', inner)
    out = []
    labels = []
    idx = 0
    for part in parts:
        if not part:
            continue
        m = LABEL_EMBED_RE.fullmatch(part)
        if m:
            lbl = m.group(1)
            labels.append((idx, lbl))
            out.extend([0,0,0,0])
            idx += 4
        else:
            for tok in part.strip().split():
                if not tok:
                    continue
                if re.fullmatch(r'[0-9A-Fa-f]{2}', tok):
                    out.append(int(tok,16)); idx += 1
                else:
                    tok2 = re.sub(r'[^0-9A-Fa-f]', '', tok)
                    for k in range(0, len(tok2), 2):
                        b = tok2[k:k+2]
                        if len(b)==2:
                            out.append(int(b,16)); idx += 1
    return out, labels

def match_at_offset(pattern, bytes_list: List[int], labels: List[Tuple[int,str]], start_offset: int):
    tokens = pattern['tokens']
    pos = start_offset
    arg_values = {}
    for tok in tokens:
        if tok[0] == 'hex':
            if pos >= len(bytes_list):
                return None
            expected = int(tok[1], 16)
            if bytes_list[pos] != expected:
                return None
            pos += 1
        elif tok[0] == 'arg':
            parts = tok[1].split()
            if len(parts) == 1:
                typ = 'byte'
                name = parts[0]
            else:
                typ = parts[0]
                name = parts[1]
            if typ == 'byte':
                if pos+1 > len(bytes_list): return None
                lbl = next((lbl for (i,lbl) in labels if i==pos), None)
                if lbl:
                    arg_values[name] = lbl
                else:
                    arg_values[name] = bytes_list[pos]
                pos += 1
            elif typ == 'short':
                if pos+2 > len(bytes_list): return None
                lbl = next((lbl for (i,lbl) in labels if i==pos), None)
                if lbl:
                    arg_values[name] = lbl
                else:
                    val = bytes_list[pos] | (bytes_list[pos+1] << 8)
                    arg_values[name] = val
                pos += 2
            elif typ == 'long':
                if pos+4 > len(bytes_list): return None
                lbl = next((lbl for (i,lbl) in labels if i==pos), None)
                if lbl:
                    arg_values[name] = lbl
                else:
                    val = (bytes_list[pos] | (bytes_list[pos+1]<<8) | (bytes_list[pos+2]<<16) | (bytes_list[pos+3]<<24))
                    arg_values[name] = val
                pos += 4
            elif typ == 'char':
                if pos+1 > len(bytes_list): return None
                arg_values[name] = bytes_list[pos]
                pos += 1
            elif typ == 'str':
                return None
            else:
                return None
        else:
            return None
    consumed = pos - start_offset
    return consumed, arg_values

def format_arg(val, typ_hint=None):
    if isinstance(val, str):
        return val
    if typ_hint == 'char' and 32 <= val <= 126:
        return repr(chr(val))
    return str(val)

def _hex_comment(pattern, raw_ints):
    """Build a hex comment string by reading type widths from pattern tokens.
    Labels (None entries) are skipped. Returns e.g. '// 0x0122, 0x2C, 0x01' or ''."""
    # Build name->type map from the pattern's arg tokens
    type_map = {}
    for tok in (pattern.get('tokens') or []):
        if tok[0] == 'arg':
            parts = tok[1].split()
            if len(parts) >= 2:
                type_map[parts[-1]] = parts[0]   # e.g. 'num' -> 'long'
            else:
                type_map[parts[0]] = 'byte'
    params = pattern.get('params') or []
    parts = []
    for p, v in zip(params, raw_ints):
        if v is None:
            continue  # label arg — skip
        # param string may be "type name" or just "name"
        pparts = p.split()
        pname = pparts[-1]
        typ = type_map.get(pname, pparts[0] if len(pparts) > 1 else 'byte')
        if typ == 'long':
            parts.append(f'0x{v & 0xFFFFFFFF:08X}')
        elif typ == 'short':
            parts.append(f'0x{v & 0xFFFF:04X}')
        else:  # byte, char, or unknown
            parts.append(f'0x{v & 0xFF:02X}')
    if not parts:
        return ''
    return '// ' + ', '.join(parts)


# Sound effect index -> name (from CCScript reference, Sound -> Effect table)
_SOUND_TABLE = {
    0: None,   # Load from argument register
    1: 'SND_CURSORBLIP', 2: 'SND_CURSORCONFIRM', 3: 'SND_CURSORBEEP',
    4: 'SND_CURSORNAME', 5: 'SND_ERRORBEEP',
    6: None,   # no sound
    7: 'SND_TEXTBLIP', 8: 'SND_DOOROPEN', 9: 'SND_DOORCLOSE',
    10: 'SND_PHONERING', 11: 'SND_PHONEPICKUP', 12: 'SND_KACHING',
    13: 'SND_FOOTSTEP', 14: 'SND_BEEOOP', 15: 'SND_BUZZ',
    16: 'SND_GIFTOPEN', 17: 'SND_LANDING', 18: 'SND_STAIRS',
    19: 'SND_HIGHBUZZ', 20: 'SND_LOWBUZZ', 21: 'SND_SQUEAKYBUZZ',
    22: 'SND_TRUMPET', 23: 'SND_MUFFLEDBUZZ', 24: 'SND_HEROATTACK',
    25: 'SND_MONSTERATTACK', 26: 'SND_BASH', 27: 'SND_SHOOT',
    28: 'SND_PRAYING', 29: 'SND_PSI1', 30: 'SND_NORMALBASH',
    31: 'SND_SMASH', 32: 'SND_HERODEATH', 33: 'SND_ENEMYDEATH',
    34: 'SND_GIFTOPEN2', 35: 'SND_DODGE', 36: 'SND_RECOVER',
    37: 'SND_STATUSRECOVER', 38: 'SND_SHIELD1', 39: 'SND_SHIELD2',
    40: 'SND_STATSUP', 41: 'SND_STATSDOWN', 42: 'SND_HYPNOSIS',
    43: 'SND_MAGNET', 44: 'SND_PARALYSIS', 45: 'SND_BRAINSHOCK1',
    46: 'SND_THUMP', 47: 'SND_CRITICAL', 48: 'SND_ROCKIN1',
    49: 'SND_ROCKIN2', 50: 'SND_ROCKIN3', 51: 'SND_FIRE1',
    52: 'SND_FIRE2', 53: 'SND_FIRE3', 54: 'SND_BRAINSHOCK2',
    55: 'SND_PSI2', 56: 'SND_FREEZE1', 57: 'SND_FREEZE2',
    58: 'SND_DEFENSEDOWN1', 59: 'SND_DEFENSEDOWN2', 60: 'SND_THUNDERMISS',
    61: 'SND_THUNDERHIT1', 62: 'SND_THUNDERHIT2', 63: 'SND_THUNDERDAMAGE',
    64: 'SND_STARSTORM', 65: 'SND_FLASH1', 66: 'SND_FLASH2',
    67: 'SND_FLASH3', 68: 'SND_EAT', 69: 'SND_QUIETBEEP',
    70: 'SND_MISSILE', 71: 'SND_HISS', 72: 'SND_STATUSCHANGE',
    73: 'SND_PING', 74: 'SND_THUMP2', 75: 'SND_MBR',
    76: 'SND_MAGNET2', 77: 'SND_MAGNET3', 78: 'SND_WHIRR',
    79: 'SND_PARALYSIS2', 80: 'SND_BRAINSHOCK3', 81: 'SND_DRILL',
    82: 'SND_SPORES', 83: 'SND_AFFLICTED', 84: 'SND_KERPOW',
    85: 'SND_MYSTERIOUS', 86: 'SND_WARBLING',
    87: None,   # no sound
    88: 'SND_SPROING', 89: 'SND_REFUEL', 90: 'SND_GIYGASWEAK',
    91: 'SND_FIRE4', 92: 'SND_MUFFLEDBUZZ2', 93: 'SND_SHIELDREFLECT',
    94: 'SND_CHIRP', 95: 'SND_BUTTERFLY', 96: 'SND_POSSESSED',
    97: 'SND_STAIRS2', 98: 'SND_DRUMS', 99: 'SND_STARMASTER',
    100: 'SND_EDENWARP', 101: 'SND_BIRDS', 102: 'SND_SPECIALITEM',
    103: 'SND_LEARNPSI', 104: 'SND_CHICKEN', 105: 'SND_SPHINX1',
    106: 'SND_SPHINX2', 107: 'SND_SPHINX3', 108: 'SND_SPHINX4',
    109: 'SND_SPHINX5', 110: 'SND_PYRAMIDOPEN', 111: 'SND_RAPIDKNOCK',
    112: None,  # no sound
    113: 'SND_MANIMANI', 114: 'SND_CREEPY', 115: 'SND_BOXOPEN1',
    116: 'SND_BOXTAKE',
    117: None,  # unknown
    118: 'SND_CHICKEN2', 119: 'SND_PSI3', 120: 'SND_GUITAR',
    121: 'SND_BEEP2', 122: 'SND_TRUMPETBLAST',
    123: None,  # no sound
    124: 'SND_FUNKY',
}


# --- Hardcoded alias/define tables ---
# group value -> SCR_STATUS_GROUP_N name
_INFLICT_GROUP = {1: 'SCR_STATUS_GROUP_0', 2: 'SCR_STATUS_GROUP_1', 3: 'SCR_STATUS_GROUP_2',
                  4: 'SCR_STATUS_GROUP_3', 5: 'SCR_STATUS_GROUP_4', 6: 'SCR_STATUS_GROUP_5',
                  7: 'SCR_STATUS_GROUP_6'}
# (group_value, status_value) -> SCR_STATUS_N_* name
_INFLICT_STATUS = {
    (1,1): 'SCR_STATUS_0_NONE',      (1,2): 'SCR_STATUS_0_UNCONSCIOUS',
    (1,3): 'SCR_STATUS_0_DIAMONDIZED',(1,4): 'SCR_STATUS_0_NUMB',
    (1,5): 'SCR_STATUS_0_NAUSEOUS',  (1,6): 'SCR_STATUS_0_POISONED',
    (1,7): 'SCR_STATUS_0_SUNSTROKE', (1,8): 'SCR_STATUS_0_COLD',
    (2,1): 'SCR_STATUS_1_NONE',      (2,2): 'SCR_STATUS_1_MUSHROOMIZED',
    (2,3): 'SCR_STATUS_1_POSSESSED',
    (3,1): 'SCR_STATUS_2_NONE',      (3,2): 'SCR_STATUS_2_ASLEEP',
    (3,3): 'SCR_STATUS_2_CRYING',    (3,4): 'SCR_STATUS_2_BOUND',
    (3,5): 'SCR_STATUS_2_SOLIDIFIED',
    (4,1): 'SCR_STATUS_3_NONE',      (4,2): 'SCR_STATUS_3_FEELING_STRANGE',
    (5,1): 'SCR_STATUS_4_NONE',      (5,2): 'SCR_STATUS_4_CANT_CONCENTRATE',
    (5,5): 'SCR_STATUS_4_CANT_CONCENTRATE_4',
    (6,1): 'SCR_STATUS_5_NONE',      (6,2): 'SCR_STATUS_5_HOMESICK',
    (7,1): 'SCR_STATUS_6_NONE',      (7,2): 'SCR_STATUS_6_PSI_POWER_SHIELD',
    (7,3): 'SCR_STATUS_6_PSI_SHIELD',(7,4): 'SCR_STATUS_6_POWER_SHIELD',
    (7,5): 'SCR_STATUS_6_SHIELD',
}
_FOODTYPE   = {1: 'FOODTYPE_FOOD', 2: 'FOODTYPE_DRINK', 3: 'FOODTYPE_CONDIMENT'}
_DIR_TYPE   = {1: 'TO_CHAR', 2: 'TO_NPC', 3: 'TO_SPRITE2'}
_EQUIP_TYPE = {1: 'EQUIPPABLETYPE_OFFENSIVE', 2: 'EQUIPPABLETYPE_DEFENSIVE'}
_LEARNPSI   = {(1,1): 'learn_teleport_alpha', (4,2): 'learn_starstorm_alpha',
               (4,3): 'learn_starstorm_omega', (1,4): 'learn_teleport_beta'}


def _iarg(arg_values, key, params_list):
    """Return the integer value of a named arg, or None if it's a label/missing."""
    val = arg_values.get(key)
    if val is None and arg_values:
        val = next(iter(arg_values.values()))
    if isinstance(val, int):
        return val
    return None


def _build_call_str(pattern, arg_values, raw_ints, params):
    """Return the call text string (without hex comment)."""
    name = pattern['name']
    extra = pattern.get('extra') or ''

    if pattern['pattern'] is None and extra:
        alias = extra.strip()
        if alias.startswith('"') and alias.endswith('"'):
            alias = alias[1:-1]
        # open_wallet is a pure alias for show_wallet — emit the target name directly
        if name == 'open_wallet':
            return alias
        return f"{name} {alias}"

    if not params:
        return name

    args_out = []
    has_label = False
    for p, v in zip(params, raw_ints):
        type_parts = p.split()
        typ_hint = type_parts[0] if len(type_parts) > 1 else None
        if v is None:
            has_label = True
            # recover label string from arg_values
            key = type_parts[-1]
            lval = arg_values.get(key)
            if lval is None and arg_values:
                lval = next(iter(arg_values.values()))
            args_out.append(str(lval) if lval is not None else '?')
        else:
            args_out.append(format_arg(v, typ_hint))

    # hotspot_on: 3rd arg (target) is a long address -> format as l_0xNNNNNN
    # Space before the label arg only, first two args stay comma-only separated.
    if name == 'hotspot_on' and len(raw_ints) == 3 and raw_ints[2] is not None:
        target_val = raw_ints[2] & 0xFFFFFF  # strip the 0x00 high byte
        return f'hotspot_on({args_out[0]},{args_out[1]}, l_0x{target_val:x})'

    # --- Alias / define substitution rules (hardcoded per spec) ---

    # compare_register: alias based on reg value
    if name == 'compare_register' and len(raw_ints) == 2 and raw_ints[1] is not None:
        num_str = args_out[0]
        reg = raw_ints[1]
        if reg == 0: return f'compare_result({num_str})'
        if reg == 1: return f'compare_argument({num_str})'
        if reg == 2: return f'compare_counter({num_str})'

    # char_freeze(0xFF) -> party_freeze / char_unfreeze(0xFF) -> party_unfreeze
    if name == 'char_freeze' and raw_ints == [255]:
        return 'party_freeze'
    if name == 'char_unfreeze' and raw_ints == [255]:
        return 'party_unfreeze'

    # hide_char_with_style(0xFF, 6) -> hide_party
    if name == 'hide_char_with_style' and raw_ints == [255, 6]:
        return 'hide_party'

    # show_char(0xFF, X) -> show_party(X)
    if name == 'show_char' and len(raw_ints) == 2 and raw_ints[0] == 255:
        style = args_out[1]
        return f'show_party({style})'

    # gfx_text(1) -> smash_text, gfx_text(2) -> you_won
    if name == 'gfx_text' and raw_ints == [1]:
        return 'smash_text'
    if name == 'gfx_text' and raw_ints == [2]:
        return 'you_won'

    # get_user_info aliases
    if name == 'get_user_info':
        if raw_ints == [1]: return 'get_user_gender'
        if raw_ints == [2]: return 'get_user_and_cohort_count'

    # get_target_info aliases
    if name == 'get_target_info':
        if raw_ints == [1]: return 'get_target_gender'
        if raw_ints == [2]: return 'get_target_and_cohort_count'

    # get_dad_deposit_money_base aliases
    if name == 'get_dad_deposit_money_base':
        if raw_ints == [1]: return 'get_dad_deposit_money'
        if raw_ints == [2]: return 'clear_dad_deposit_money'

    # text_blips aliases
    if name == 'text_blips':
        if raw_ints == [1]: return 'text_blips_default'
        if raw_ints == [2]: return 'text_blips_on'
        if raw_ints == [3]: return 'text_blips_off'

    # event aliases (only 5 and 6 are aliased)
    if name == 'event':
        if raw_ints == [5]: return 'OSS_on'
        if raw_ints == [6]: return 'OSS_off'

    # learnpsi aliases
    if name == 'learnpsi' and len(raw_ints) == 2 and None not in raw_ints:
        alias = _LEARNPSI.get(tuple(raw_ints))
        if alias:
            return alias

    # inflict_status: substitute group and status args with named constants
    if name == 'inflict_status' and len(raw_ints) == 3 and raw_ints[1] is not None and raw_ints[2] is not None:
        char_arg = args_out[0]
        grp_val  = raw_ints[1]
        sts_val  = raw_ints[2]
        grp_name = _INFLICT_GROUP.get(grp_val, str(grp_val))
        sts_name = _INFLICT_STATUS.get((grp_val, sts_val), str(sts_val))
        return f'inflict_status({char_arg}, {grp_name}, {sts_name})'

    # get_food_type
    if name == 'get_food_type' and len(raw_ints) == 1 and raw_ints[0] is not None:
        fname = _FOODTYPE.get(raw_ints[0])
        if fname:
            return f'get_food_type({fname})'

    # get_dir_from_sprite: only to_type uses defines
    if name == 'get_dir_from_sprite' and len(raw_ints) == 3 and raw_ints[1] is not None:
        to_name = _DIR_TYPE.get(raw_ints[1])
        if to_name:
            return f'get_dir_from_sprite({args_out[0]}, {to_name}, {args_out[2]})'

    # get_equippable_item_type
    if name == 'get_equippable_item_type' and len(raw_ints) == 1 and raw_ints[0] is not None:
        ename = _EQUIP_TYPE.get(raw_ints[0])
        if ename:
            return f'get_equippable_item_type({ename})'

    sep = ", " if has_label else ","
    return f"{name}({sep.join(args_out)})"


def build_call_text(pattern, arg_values: Dict[str,Any]):
    """Return (call_text, hex_comment) where hex_comment is e.g. '// 0x01, 0x02' or ''."""
    params = pattern['params']

    # Resolve raw int values (None for labels) in param order
    raw_ints = []
    for p in params:
        key = p.split()[-1]
        val = arg_values.get(key)
        if val is None and arg_values:
            val = next(iter(arg_values.values()))
        raw_ints.append(int(val) if isinstance(val, int) else None)

    call_str = _build_call_str(pattern, arg_values, raw_ints, params)
    comment  = _hex_comment(pattern, raw_ints)
    # OSS_on/off: replace byte comment with the full original command form
    if call_str == 'OSS_on':  comment = '// event(5)'
    if call_str == 'OSS_off': comment = '// event(6)'
    return call_str, comment

def reconstruct_leftover(bytes_list: List[int], labels: List[Tuple[int,str]], start: int, end: int) -> str:
    parts = []
    i = start
    while i < end:
        lbl = next((lbl for (idx,lbl) in labels if idx==i), None)
        if lbl:
            parts.append(f"{{e({lbl})}}")
            i += 4
        else:
            parts.append(f"{bytes_list[i]:02X}")
            i += 1
    return " ".join(parts)

def process_text(text: str, patterns: List[Dict[str,Any]], strict: bool=False) -> str:
    i = 0
    out_lines = []
    # Track if we emitted a load_str to remove a following eob line
    prev_emitted_load_str = False

    while i < len(text):
        m = HEX_BLOCK_RE.search(text, i)
        if not m:
            remaining = text[i:]
            if prev_emitted_load_str:
                remaining = re.sub(r'^\s*eob\s*\r?\n', '', remaining, count=1)
                prev_emitted_load_str = False
            out_lines.append(remaining)
            break

        # --- unified match handling (replace entire quoted literal + optional eob with load_str line) ---
        before = text[i:m.start()]
        if prev_emitted_load_str:
            before = re.sub(r'\n[ \t]*eob[ \t]*\r?$', '\n', before, count=1)
            prev_emitted_load_str = False

        # Check if bracket was inside a quoted token with suffix chars before closing quote.
        # e.g. "[1C 01 12])" next  ->  "{stat(18)})" next
        # Also handles leading whitespace after the quote: '" [19 02]No"' -> strip the space.
        before_rstripped = before.rstrip()
        # opening_quote_before: the bracket immediately follows an opening quote.
        # Combine `before` (text before regex match start) and m.group(1) (text
        # captured as prefix within the match) to get the full prefix up to '['.
        # The opening quote is present when that combined prefix ends with a bare quote.
        _full_prefix = before + m.group(1)  # everything from i up to '['
        _full_prefix_rs = _full_prefix.rstrip()
        opening_quote_before = (
            _full_prefix_rs
            and _full_prefix_rs[-1] in ('"', "'")
            and (len(_full_prefix_rs) < 2 or _full_prefix_rs[-2] != '\\')
            # The char before the quote must be whitespace or start-of-content
            # (not text), so the quote is truly an opening quote, not a close quote
            # of a preceding token followed by a separate open quote.
            and (len(_full_prefix_rs) < 2 or _full_prefix_rs[-2] in ('\t', ' ', '\n', '\r', ',', '('))
        )
        quoted_suffix = None  # suffix chars between m.end() and closing quote, e.g. ")"
        if opening_quote_before:
            mqs = re.match(r'^([^"\[\]\n]*)["\']', text[m.end():])
            if mqs:
                quoted_suffix = mqs.group(1)

        # Strip the opening quote from the full prefix when opening_quote_before.
        # Also capture any text that sits between the opening quote and the bracket —
        # e.g. '"  [1C 08 01]' has '  ' between the quote and '['.
        _opening_quote_prefix_text = ''
        if opening_quote_before:
            _last_q_in_prefix = _full_prefix_rs.rfind('"')
            if _last_q_in_prefix >= 0:
                # Text between the quote and the bracket (from full, un-rstripped prefix)
                _opening_quote_prefix_text = _full_prefix[_last_q_in_prefix + 1:]
            before = _full_prefix_rs[:-1]

        # Detect if bracket is embedded inside a quoted string (mid-text, not at start).
        # Use the bracket's actual position (m.start(2)-1 = '[') to count preceding quotes.
        _bracket_pos = m.start(2) - 1  # position of '['
        _line_start = text.rfind('\n', 0, _bracket_pos) + 1
        _pre = text[_line_start:_bracket_pos]
        embedded_in_string = (
            not opening_quote_before
            and (len(re.findall(r'(?<!\\)"', _pre)) % 2 == 1)
        )

        # When embedded: before contains '...prefix\n\t"text' where text is inside a
        # quoted string. Strip the '"text' part from before; we'll emit it separately
        # as a closed quoted string right after appending the prefix.
        _embedded_text_before = None
        _embedded_text_raw = None
        if embedded_in_string and not opening_quote_before:
            _bef_rs = before.rstrip()
            _last_q = _bef_rs.rfind('"')
            if _last_q >= 0:
                _text_after_q = before[_last_q+1:]  # text between open-quote and bracket (preserves trailing space)
                # Use original before for text (preserving spaces); rstripped version for truncation.
                before = _bef_rs[:_last_q]
                if _text_after_q:  # actual text content
                    _indent = _bef_rs[:_last_q]
                    # Extract just the indent from the line containing the open-quote
                    _q_line_start = _bef_rs.rfind('\n', 0, _last_q) + 1
                    _q_indent = _bef_rs[_q_line_start:_q_line_start + len(_bef_rs[_q_line_start:]) - len(_bef_rs[_q_line_start:].lstrip('\t '))]
                    _embedded_text_before = '"' + _text_after_q + '"'
                    _embedded_text_raw = _text_after_q  # raw text for inline embedding
                else:
                    _embedded_text_raw = ''

        out_lines.append(before)
        if _embedded_text_before is not None:
            out_lines.append(_embedded_text_before)


        inner = m.group(2)
        bytes_list, labels = bytes_from_block_text(inner)
        L = len(bytes_list)

        # Special-character bytes [AB]-[CF] inside text strings must not be
        # converted to commands — they are font/display character codes.
        if L == 1 and not labels and 0x50 <= bytes_list[0] <= 0xCF:
            bracket_str = '[' + format(bytes_list[0], '02X') + ']'
            if opening_quote_before:
                # Re-close the quote: before already had its quote stripped;
                # grab suffix up to next closing quote and re-wrap everything.
                suffix_m = re.match(r'^([^"\n]*)["]\'?', text[m.end():])
                suf = suffix_m.group(1) if suffix_m else ''
                end_skip = suffix_m.end() if suffix_m else 0
                out_lines.append('"' + before.lstrip('\t') + bracket_str + suf + '"')
                i = m.end() + end_skip
            elif embedded_in_string:
                # Char code is mid-text inside a quoted string.
                # Use the inline scan approach: keep it embedded in the string.
                _prefix_text = _embedded_text_raw if _embedded_text_raw is not None else ''
                assembled = _prefix_text + bracket_str
                # Suppress separate _embedded_text_before already appended
                if _embedded_text_before is not None and out_lines and out_lines[-1] == _embedded_text_before:
                    out_lines.pop()
                # Remove bare indent entry
                if _embedded_text_raw is not None and out_lines and out_lines[-1].strip() == '':
                    out_lines.pop()
                # Scan rest of string for more content
                scan_i = m.end()
                while scan_i < len(text):
                    rest = text[scan_i:]
                    bkt_m2 = re.search(r'["\n]', rest)
                    if not bkt_m2:
                        assembled += rest
                        scan_i = len(text)
                        break
                    assembled += rest[:bkt_m2.start()]
                    scan_i += bkt_m2.start()
                    if rest[bkt_m2.start()] in ('"', '\n'):
                        scan_i += 1
                        break
                if out_lines and re.sub(r'[\t ]+$', '', out_lines[-1]).endswith('\n'):
                    out_lines[-1] = re.sub(r'[\t ]+$', '', out_lines[-1])
                    _inline_pfx = ''
                else:
                    _inline_pfx = '\n'
                out_lines.append(_inline_pfx + '\t"' + assembled + '"')
                i = scan_i
            else:
                out_lines.append(bracket_str)
                i = m.end()
            continue

        # detect load_str pattern and capture possible tail
        replaced = None
        consumed_extra_chars = 0
        tail_quoted = False
        if L >= 2 and bytes_list[0] == 0x19 and bytes_list[1] == 0x02 and not labels:
            tail = text[m.end():]
            # When [19 02] appears inside a quoted string (opening_quote_before),
            # the string content follows directly — read up to the closing quote.
            if opening_quote_before and not tail.startswith('"') and not tail.startswith("'"):
                mq_inline = re.match(r'^([^"\n]*)"', tail)
                if mq_inline:
                    content = mq_inline.group(1)
                    consumed_extra_chars = mq_inline.end()  # includes closing quote
                    tail_quoted = True
                    replaced = f'load_str("{content}")'
            if replaced is None:
                mq = re.match(r'^"([^"]*)"', tail) or re.match(r"^'([^']*)'", tail)
                if mq:
                    content = mq.group(1)
                    consumed_extra_chars = mq.end()   # includes both quotes
                    tail_quoted = True
                    # normalize content just in case
                    if len(content) >= 1 and content[0] in ('"', "'"):
                        content = content.lstrip('"\'')

                    if len(content) >= 1 and content[-1] in ('"', "'"):
                        content = content.rstrip('"\'')

                    replaced = f'load_str("{content}")'
                else:
                    mu = re.match(r'^([^\s\r\n]+)', tail)
                    if mu:
                        content = mu.group(1)
                        consumed_extra_chars = mu.end()
                        if (content.startswith('"') and content.endswith('"')) or (content.startswith("'") and content.endswith("'")):
                            content = content[1:-1]
                            tail_quoted = True
                        else:
                            if consumed_extra_chars < len(tail) and tail[consumed_extra_chars] in ('"', "'"):
                                consumed_extra_chars += 1

                        # strip any lingering surrounding quotes
                        if len(content) >= 1 and content[0] in ('"', "'"):
                            content = content.lstrip('"\'')

                        if len(content) >= 1 and content[-1] in ('"', "'"):
                            content = content.rstrip('"\'')

                        replaced = f'load_str("{content}")'

        if replaced is not None:
            # Compute span to remove: include opening quote if present, bracket, tail (if any),
            # and also try to remove a stray unmatched closing quote after the span.
            span_start = m.start()
            if span_start > 0 and text[span_start - 1] in ('"', "'") and (span_start < 2 or text[span_start - 2] != '\\'):
                span_start -= 1

            span_end = m.end() + consumed_extra_chars

            # If we didn't consume a quoted tail but there's an immediate closing quote left over, consume it.
            if not tail_quoted and span_end < len(text) and text[span_end] in ('"', "'") and (span_end == 0 or text[span_end - 1] != '\\'):
                span_end += 1

            # Consume an immediate following eob line entirely (and any leading newline) if present.
            em = re.match(r'^[ \t]*\r?\n?[ \t]*eob[ \t]*(\r?\n)?', text[span_end:])
            if em:
                span_end += em.end()

            # Emit the replacement as a full standalone line (with newline).
            out_lines.append(replaced)
            out_lines.append('\n')

            # Advance past the removed span so nothing from it can be appended later.
            i = span_end

            prev_emitted_load_str = False
            continue

        # --- end unified match handling ---

        # Fallback: existing matching logic
        done = False

        # Pre-check: switch_call / switch_goto must win before loop1 can match
        # a partial pattern (e.g. 'give') at a non-zero offset inside their payload.
        for sw_pat in patterns:
            if sw_pat['name'] not in ('switch_call', 'switch_goto'):
                continue
            sw_res = match_at_offset(sw_pat, bytes_list, labels, 0)
            if not sw_res:
                continue
            sw_consumed, sw_args = sw_res
            if sw_consumed >= L:
                break  # full match — let loop2 handle it
            # Check that all remaining bytes are label references only
            sw_j = sw_consumed
            # For switch_call only: first label is overflow/default, not a switch_entry.
            if sw_pat['name'] == 'switch_call':
                sw_overflow = next((lbl for (idx, lbl) in labels if idx == sw_j), None)
                if sw_overflow:
                    sw_j += 4
            sw_entries = []
            sw_only = True
            while sw_j < L:
                sw_lbl = next((lbl for (idx, lbl) in labels if idx == sw_j), None)
                if sw_lbl:
                    sw_entries.append(sw_lbl)
                    sw_j += 4
                else:
                    sw_only = False
                    break
            if sw_only and sw_entries:
                sw_calltxt, sw_hexcmt = build_call_text(sw_pat, sw_args)
                bracket_was_quoted = (m.group(1) != '') or embedded_in_string or opening_quote_before
                sw_main = sw_calltxt
                if not bracket_was_quoted:
                    sw_main = '{' + sw_main + '}'
                sw_cmt = ('\t' + sw_hexcmt) if bracket_was_quoted and sw_hexcmt else ''
                out_lines.append(sw_main + sw_cmt + '\n')
                for sw_k, sw_e in enumerate(sw_entries):
                    nl = '\n' if sw_k < len(sw_entries) - 1 else ''
                    out_lines.append('\t\t' + f'switch_entry({sw_e})' + nl)
                i = m.end()
                done = True
            break

        for pat in patterns:
            if not pat['tokens']:
                continue
            if done:
                break
            for start_off in range(0, max(1, L)):
                res = match_at_offset(pat, bytes_list, labels, start_off)
                if not res:
                    continue
                consumed_bytes, arg_values = res
                prefix = ""
                if start_off > 0:
                    pref = reconstruct_leftover(bytes_list, labels, 0, start_off)
                    prefix = "[" + pref + "] "
                calltxt, hexcmt = build_call_text(pat, arg_values)
                suffix = ""
                if start_off + consumed_bytes < L:
                    suf = reconstruct_leftover(bytes_list, labels, start_off + consumed_bytes, L)
                    suffix = " [" + suf + "]"

                # Determine whether original bracket was quoted (group 1 holds the optional quote)
                # Also treat as quoted when bracket is embedded inside a quoted string.
                bracket_was_quoted = (m.group(1) != '') or embedded_in_string or opening_quote_before

                # --- Special-case for switch_goto / switch_call followed only by embedded labels ---
                if pat['name'] in ('switch_goto', 'switch_call') and start_off + consumed_bytes < L:
                    entries = []
                    j = start_off + consumed_bytes
                    # For switch_call only: first label is overflow/default, not a switch_entry.
                    if pat['name'] == 'switch_call':
                        overflow_lbl = next((lbl for (idx, lbl) in labels if idx == j), None)
                        if overflow_lbl:
                            j += 4  # advance past overflow label
                    only_labels = True
                    while j < L:
                        lbl = next((lbl for (idx, lbl) in labels if idx == j), None)
                        if lbl:
                            entries.append(lbl)
                            j += 4
                        else:
                            only_labels = False
                            break
                    if only_labels and entries:
                        # emit main call on its own line; for bracket-not-quoted inline contexts we wrap in braces.
                        main_call = calltxt
                        if not bracket_was_quoted:
                            main_call = "{" + main_call + "}"
                        cmt = ('\t' + hexcmt) if bracket_was_quoted and hexcmt else ''
                        out_lines.append(prefix + main_call + cmt + '\n')
                        # emit indented switch_entry lines for each label (skipping overflow)
                        for k, lbl in enumerate(entries):
                            nl = '\n' if k != len(entries) - 1 else ''
                            out_lines.append('\t\t' + f"switch_entry({lbl})" + nl)
                        i = m.end()
                        done = True
                        break
                # --- end special-case ---

                # fallback: original behaviour, but wrap call in braces when the bracket sequence was not quoted
                emit_call = calltxt
                if not bracket_was_quoted:
                    emit_call = "{" + emit_call + "}"
                cmt = ('\t' + hexcmt) if (bracket_was_quoted or quoted_suffix is not None) and hexcmt else ''

                # Flow-control commands (goto_if_*, switch_goto, etc.) should always split
                # to their own line, emitting any suffix text as a new quoted string.
                # Inline-value commands (stat, name, etc.) keep wrapped with their suffix.
                _FLOW_CMDS = {
                    'goto_if_false', 'goto_if_true', 'goto_if_flag', 'switch_goto',
                    'switch_call', 'phone_call', 'give_and_return_location',
                    'music_switching_off', 'music_switching_on', 'window_switch',
                    'load_str_callonhover', 'switch_entry',
                }
                _is_flow = pat['name'] in _FLOW_CMDS
                if quoted_suffix is not None and not embedded_in_string:
                    if _is_flow:
                        # Emit command on its own line; re-open the quote for the suffix text.
                        out_lines.append(prefix + emit_call + suffix + cmt)
                        out_lines.append('\n\t"' + quoted_suffix + '"')
                        i = m.end() + len(quoted_suffix) + 1
                    else:
                        # Inline command — keep wrapped, prepend any text before bracket
                        # e.g. '"  [1C 08 01]"' -> '"  {smash_text}"'
                        # Suppress the hex comment only when there's a text prefix
                        # (the comment would appear mid-string which looks wrong);
                        # keep it when the bracket is at the very start of the quoted token.
                        inline_call = '{' + calltxt + '}'
                        emit_call = '"' + _opening_quote_prefix_text + inline_call + quoted_suffix + '"'
                        if _opening_quote_prefix_text:
                            # Has text before bracket — suppress comment (it's inside a string)
                            out_lines.append(prefix + emit_call + suffix)
                        else:
                            cmt = ('\t' + hexcmt) if hexcmt else ''
                            out_lines.append(prefix + emit_call + suffix + cmt)
                        i = m.end() + len(quoted_suffix) + 1
                elif embedded_in_string:
                    # Command was mid-text: _embedded_text_before already closed the preceding text.
                    # Flow commands go on their own line; inline commands stay embedded with {} syntax.
                    next_i = m.end()
                    if _is_flow:
                        out_lines.append('\n\t' + emit_call + suffix + cmt)
                        # Advance past the closing quote that ends the original quoted token.
                        # The closing '"' may not be immediately next — scan forward past any
                        # remaining brackets (e.g. [03] after a goto_if_flag bracket) to find it.
                        scan_close = next_i
                        while scan_close < len(text) and text[scan_close] != '"' and text[scan_close] != '\n':
                            if text[scan_close] == '[':
                                # There are more brackets before the closing quote.
                                # Each must be a flow-terminator or simple command — emit them too.
                                bk_close = text.find(']', scan_close)
                                if bk_close < 0:
                                    break
                                bk_inner2 = text[scan_close+1:bk_close]
                                bk_bl2, bk_labs2 = bytes_from_block_text(bk_inner2)
                                for bk_pat2 in patterns:
                                    bk_res2 = match_at_offset(bk_pat2, bk_bl2, bk_labs2, 0)
                                    if bk_res2 and bk_res2[0] == len(bk_bl2):
                                        bk_ct2, bk_hc2 = build_call_text(bk_pat2, bk_res2[1])
                                        out_lines.append('\n\t' + bk_ct2)
                                        break
                                scan_close = bk_close + 1
                            else:
                                scan_close += 1
                        if scan_close < len(text) and text[scan_close] == '"':
                            next_i = scan_close + 1
                        else:
                            next_i = scan_close
                    else:
                        # Inline embedded command: scan the entire remaining string content,
                        # converting further brackets to {cmd} inline, emit one complete string.
                        # Prepend any text that was before the bracket (same quoted string).
                        inline_call = '{' + calltxt + '}'
                        _prefix_text = _embedded_text_raw if _embedded_text_raw is not None else ''
                        assembled = _prefix_text + inline_call
                        # Suppress the separate _embedded_text_before since we're embedding inline
                        if _embedded_text_before is not None and out_lines and out_lines[-1] == _embedded_text_before:
                            out_lines.pop()
                        # Also remove the bare indent that was emitted as `before` (e.g. '\t')
                        if _embedded_text_raw is not None and out_lines and out_lines[-1].strip() == '':
                            out_lines.pop()
                        scan_i = m.end()
                        while scan_i < len(text):
                            # Find next bracket or closing quote
                            rest = text[scan_i:]
                            bkt_m = re.search(r'[\["\n]', rest)
                            if not bkt_m:
                                assembled += rest
                                scan_i = len(text)
                                break
                            ch = bkt_m.group(0)
                            assembled += rest[:bkt_m.start()]
                            scan_i += bkt_m.start()
                            if ch in ('"', '\n'):
                                # closing quote or newline: end of string content
                                scan_i += 1  # consume the closing quote
                                break
                            else:  # '['
                                # Try to match a bracket command inline
                                bk_end = rest.find(']', bkt_m.start())
                                if bk_end < 0:
                                    assembled += '['
                                    scan_i += 1
                                    continue
                                bk_inner = rest[bkt_m.start()+1:bk_end]
                                bk_bl, bk_labs = bytes_from_block_text(bk_inner)
                                # Flow-terminator bracket commands: these should end the
                                # current string and be emitted standalone after it.
                                _INLINE_FLOW_TERM = {
                                    'promptw', 'wait', 'next', 'linebreak', 'newline',
                                    'window_closeall', 'rtoarg', 'ctoarg',
                                }
                                bk_matched = False
                                for bk_pat in patterns:
                                    bk_res = match_at_offset(bk_pat, bk_bl, bk_labs, 0)
                                    if bk_res and bk_res[0] == len(bk_bl):
                                        bk_ct, _ = build_call_text(bk_pat, bk_res[1])
                                        if bk_pat['name'] in _INLINE_FLOW_TERM:
                                            # Emit current assembled string, then this command
                                            # standalone, then continue past closing quote.
                                            _emit_assembled = assembled if assembled else None
                                            if _emit_assembled is not None:
                                                if out_lines:
                                                    out_lines[-1] = re.sub(r'[\t ]+$', '', out_lines[-1])
                                                    _pfx = '' if out_lines[-1].endswith('\n') else '\n'
                                                else:
                                                    _pfx = '\n'
                                                out_lines.append(_pfx + '\t"' + _emit_assembled + '"')
                                            out_lines.append('\n\t' + bk_ct)
                                            assembled = None  # signal: already emitted
                                            scan_i += bk_end - bkt_m.start() + 1
                                            # Skip closing quote if present
                                            rest2 = text[scan_i:]
                                            if rest2.startswith('"'):
                                                scan_i += 1
                                            bk_matched = True
                                        else:
                                            assembled += '{' + bk_ct + '}'
                                            bk_matched = True
                                        break
                                if assembled is None:
                                    break  # flow terminator already handled
                                if bk_matched:
                                    scan_i += bk_end - bkt_m.start() + 1
                                else:
                                    assembled += '[' + bk_inner + ']'
                                    scan_i += bk_end - bkt_m.start() + 1
                        # Trim trailing whitespace from the previous out_lines entry
                        # (the truncated 'before' may end with '\t' or '\n\t' causing a blank line)
                        if assembled is not None:
                            if out_lines:
                                out_lines[-1] = re.sub(r'[\t ]+$', '', out_lines[-1])
                                _inline_prefix = '' if out_lines[-1].endswith('\n') else '\n'
                            else:
                                _inline_prefix = '\n'
                            out_lines.append(_inline_prefix + '\t"' + assembled + '"')
                        next_i = scan_i
                    i = next_i
                else:
                    i = m.end()
                    out_lines.append(prefix + emit_call + suffix + cmt)
                done = True
                break
            if done:
                break

        if done:
            continue

        for pat in patterns:
            if not pat['tokens']:
                continue
            res = match_at_offset(pat, bytes_list, labels, 0)
            if res and res[0] == L:
                # full match at offset 0
                consumed_bytes, arg_values = res
                # Determine whether original bracket was quoted
                bracket_was_quoted = (m.group(1) != '') or embedded_in_string or opening_quote_before

                # Special-case: switch_goto/switch_call with trailing-only labels
                if pat['name'] in ('switch_goto', 'switch_call') and consumed_bytes < L:
                    entries = []
                    j = consumed_bytes
                    # For switch_call only: first label is overflow/default, not a switch_entry.
                    if pat['name'] == 'switch_call':
                        overflow_lbl2 = next((lbl for (idx, lbl) in labels if idx == j), None)
                        if overflow_lbl2:
                            j += 4
                    only_labels = True
                    while j < L:
                        lbl = next((lbl for (idx, lbl) in labels if idx == j), None)
                        if lbl:
                            entries.append(lbl)
                            j += 4
                        else:
                            only_labels = False
                            break
                    if only_labels and entries:
                        main_call, hexcmt2 = build_call_text(pat, arg_values)
                        if not bracket_was_quoted:
                            main_call = "{" + main_call + "}"
                        cmt2 = ('\t' + hexcmt2) if bracket_was_quoted and hexcmt2 else ''
                        out_lines.append(main_call + cmt2 + '\n')
                        for lbl in entries:
                            out_lines.append('\t' + f"switch_entry({lbl})" + '\n')
                        i = m.end()
                        done = True
                        break

                calltxt, hexcmt3 = build_call_text(pat, res[1])
                if not bracket_was_quoted:
                    calltxt = "{" + calltxt + "}"
                cmt3 = ('\t' + hexcmt3) if bracket_was_quoted and hexcmt3 else ''
                out_lines.append(calltxt + cmt3)
                i = m.end()
                done = True
                break
        if done:
            continue

        # No pattern matched
        if strict:
            raise ValueError(f"No command pattern matched hex block: [{inner}]")
        raw = m.group(0)
        if raw.startswith('"') and raw.endswith('"'):
            out_lines.append(raw[1:-1])
        else:
            out_lines.append(raw)
        i = m.end()

    result = ''.join(out_lines)

    # open_wallet -> show_wallet (catch any that slipped through as plain text)
    result = result.replace('open_wallet', 'show_wallet')

    # sound(N) -> sound(SND_NAME)	// N
    def replace_sound(m):
        n = int(m.group(1))
        name = _SOUND_TABLE.get(n)
        if name:
            return f'sound({name})\t// {n}'
        return m.group(0)  # no name (no sound / unknown) — leave as-is
    result = re.sub(r'(?<!\{)\bsound\(([0-9]+)\)', replace_sound, result)

    # cannot_take_money(X) immediately followed by goto_if_true(L)
    # -> hasmoney(X) / goto_if_false(L)
    result = re.sub(
        r'([ \t]*)(cannot_take_money(\([^)]*\)))[ \t]*\r?\n([ \t]*)(goto_if_true(\([^)]*\)))',
        lambda m: m.group(1) + 'hasmoney' + m.group(3) + '\n' + m.group(4) + 'goto_if_false' + m.group(6),
        result
    )

    # Move any mid-line hex comment to the true end of its line.
    # Only applies when what follows the comment is a plain keyword (e.g. 'next'),
    # not more hex values. e.g. '"{stat(18)})"\t// 0x12 next' -> '"{stat(18)})" next\t// 0x12'
    result = re.sub(r'(\t// 0x[0-9A-Fa-f]+)( [A-Za-z][A-Za-z0-9_]*)(?=\n|$)',
                    lambda m: m.group(2) + m.group(1)
                        if not re.match(r'^(pause|sound|wait|eob|end)$', m.group(2).strip())
                        else m.group(0), result)


    # Pause symbol substitution inside quoted strings.
    # Only replace when the pause is NOT followed by two spaces.
    # Mapping: pause(30)->||, pause(20)->/|, pause(15)->|, pause(5)->/
    _PAUSE_SYMBOLS = [
        (30, '||'),
        (20, '/|'),
        (15, '|'),
        (10, '//'),
        (5,  '/'),
    ]

    def _subst_pauses_in_quoted(m):
        content = m.group(0)
        for val, sym in _PAUSE_SYMBOLS:
            pat = '{pause(' + str(val) + ')}'
            # Only replace when NOT followed by two spaces
            content = re.sub(
                re.escape(pat) + r'(?!  )',
                sym,
                content
            )
        return content

    # Apply only inside quoted strings (between double quotes on the same line)
    result = re.sub(r'"[^"\n]*"', _subst_pauses_in_quoted, result)

    # Final cleanup: remove any "eob" line immediately following a load_str line (safety-net)
    result = re.sub(r'(?m)^[ \t]*load_str\(".*?"\)[ \t]*\r?\n[ \t]*eob[ \t]*\r?\n', lambda m: m.group(0).splitlines()[0] + '\n', result, count=0)

    return result

def load_cmd_defines_and_aliases(path: str):
    """
    Parse a commands file and return:
      cmd_defines: {cmd_name: [(int_value, define_name), ...]} in file order
      alias_map:   {(base_cmd_name, (int_arg, ...)): alias_name}
    """
    # Collect all defines globally so alias args like LEARN_TELEPORT_ALPHA can be resolved
    global_defines = {}
    with open(path, 'r', encoding='utf-8') as f:
        raw = f.read()
    raw_clean = re.sub(r'/\*.*?\*/', '', raw, flags=re.DOTALL)
    define_re_g = re.compile(r'^\s*define\s+(\S+)\s*=\s*(\S+)', re.IGNORECASE)
    for line in raw_clean.splitlines():
        line_s = re.sub(r'//.*$', '', line).strip()
        m = define_re_g.match(line_s)
        if m:
            dname, dval = m.group(1), m.group(2)
            try:
                global_defines[dname] = int(dval, 16) if dval.lower().startswith('0x') else int(dval)
            except ValueError:
                pass

    cmd_defines: Dict[str, List] = {}
    alias_map: Dict[tuple, str] = {}

    cmd_re = re.compile(r'^command\s+([A-Za-z_]\w*)', re.IGNORECASE)
    ind_define_re = re.compile(r'^\s{2,}define\s+(\S+)\s*=\s*(\S+)', re.IGNORECASE)
    zero_alias_re = re.compile(r'^\s{2,}command\s+([A-Za-z_]\w*)\s+([A-Za-z_]\w*)\(([^)]*)\)\s*$')

    current_cmd = None
    for line in raw_clean.splitlines():
        line_s = re.sub(r'//.*$', '', line).rstrip()
        if not line_s.strip():
            continue
        m = cmd_re.match(line_s)
        if m and line_s[0] not in (' ', '\t'):
            current_cmd = m.group(1)
            continue
        m = ind_define_re.match(line_s)
        if m and current_cmd:
            dname, dval_s = m.group(1), m.group(2)
            try:
                dval = int(dval_s, 16) if dval_s.lower().startswith('0x') else int(dval_s)
                cmd_defines.setdefault(current_cmd, []).append((dval, dname))
            except ValueError:
                pass
            continue
        m = zero_alias_re.match(line_s)
        if m:
            alias_name, base_cmd = m.group(1), m.group(2)
            raw_args = [a.strip() for a in m.group(3).split(',') if a.strip()]
            resolved = []
            ok = True
            for a in raw_args:
                try:
                    resolved.append(int(a, 16) if a.lower().startswith('0x') else int(a))
                except ValueError:
                    if a in global_defines:
                        resolved.append(global_defines[a])
                    else:
                        ok = False
                        break
            if ok:
                alias_map[(base_cmd, tuple(resolved))] = alias_name

    return cmd_defines, alias_map


def load_flags_file(path: str) -> Dict[int, str]:
    """Parse a flags.ccs file and return a dict mapping flag number -> flag name."""
    flag_map = {}
    define_re = re.compile(r'^\s*define\s+(\S+)\s*=\s*flag\s+(0x[0-9A-Fa-f]+|\d+)', re.IGNORECASE)
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = re.sub(r'//.*$', '', line)
            m = define_re.match(line)
            if m:
                name = m.group(1)
                raw_num = m.group(2)
                num = int(raw_num, 16) if raw_num.lower().startswith('0x') else int(raw_num)
                flag_map[num] = name
    return flag_map


def apply_flag_names(text: str, flag_map: Dict[int, str]) -> str:
    """Replace flag numbers in set/unset/isset/goto_if_flag calls with named constants."""

    def replace_set_unset(m):
        cmd = m.group(1)
        num = int(m.group(2))
        if num in flag_map:
            return cmd + '(' + flag_map[num] + ')' + chr(9) + '// ' + str(num)
        return m.group(0)

    def replace_goto_if_flag(m):
        num = int(m.group(1))
        rest = m.group(2)
        if num in flag_map:
            # m.group(3) is any existing hex comment — absorbed and replaced
            return 'goto_if_flag(' + flag_map[num] + rest + ')' + chr(9) + '// 0x{:04X}, {}'.format(num, num)
        return m.group(0)

    pat1 = re.compile(r'(?<![A-Za-z_])(set|unset|isset)[(]flag ([0-9]+)[)]')
    pat2 = re.compile(r'goto_if_flag[(]([0-9]+)(,[^)]*)[)]([ \t]*//[^\n]*)?')
    text = pat1.sub(replace_set_unset, text)
    text = pat2.sub(replace_goto_if_flag, text)
    return text
def main():
    ap = argparse.ArgumentParser(description="Convert bracketed hex blocks to command calls using command definitions.")
    ap.add_argument('commands', help='commands definition file')
    ap.add_argument('input', help='input file to process')
    ap.add_argument('output', help='output file path to write converted text')
    ap.add_argument('--strict', action='store_true', help='error when a hex block cannot be matched')
    ap.add_argument('--flags', help='optional flags definition file (flags.ccs)')
    args = ap.parse_args()

    cmd_defs = load_command_file(args.commands)
    if not cmd_defs:
        print("No command definitions found.", file=sys.stderr)
        sys.exit(1)
    patterns = build_patterns(cmd_defs)

    with open(args.input, 'r', encoding='utf-8') as f:
        text = f.read()
    # Stage 1: split compound hex/brace lines
    text = split_ccs_text(text)
    # Stage 2: convert hex bracket blocks to named commands
    out_text = process_text(text, patterns, strict=args.strict)

    if args.flags:
        flag_map = load_flags_file(args.flags)
        out_text = apply_flag_names(out_text, flag_map)

    out_dir = os.path.dirname(args.output)
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    with open(args.output, 'w', encoding='utf-8') as f:
        f.write(out_text)
    print("Wrote", args.output)

if __name__ == '__main__':
    main()
