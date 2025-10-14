#!/bin/zsh

parse_psv_to_json_jq() {
    jq -Rs '
        split("\n") | map(select(length > 0)) |
        .[0] as $headers | ($headers | split("|") | map(gsub("^\\s+|\\s+$"; ""))) as $h |
        .[1:] | map(
            split("|") | map(gsub("^\\s+|\\s+$"; "")) |
            [$h, .] | transpose | map({(.[0]): .[1]}) | add
        )
    '
}

parse_psv_to_json_jq
