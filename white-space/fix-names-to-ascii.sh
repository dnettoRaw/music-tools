#!/bin/bash

# dnetto v0.2.1 - Improved performance with logging

# Normalize all MP3 files in the current directory using mp3gain (wrapper script)

debug=0

declare -a replace_map=(
  '$'='S' 'Ã'='A' 'Ã¨'='e' 'Ãª'='e' 'Ã©'='e' 'À'='A' 'Á'='A' 'Â'='A' 'Ä'='A' 'Å'='A' 'Æ'='AE' 'Ç'='C'
  'È'='E' 'É'='E' 'Ê'='E' 'Ë'='E' 'Ì'='I' 'Í'='I' 'Î'='I' 'Ï'='I' 'Ð'='D' 'Ñ'='N' 'Ò'='O' 'Ó'='O' 'Ô'='O'
  'Õ'='O' 'Ö'='O' 'Ø'='O' 'Ù'='U' 'Ú'='U' 'Û'='U' 'Ü'='U' 'Ý'='Y' 'ß'='s' 'à'='a' 'á'='a' 'â'='a' 'ã'='a'
  'ä'='a' 'å'='a' 'æ'='ae' 'ç'='c' 'è'='e' 'é'='e' 'ê'='e' 'ë'='e' 'ì'='i' 'í'='i' 'î'='i' 'ï'='i' 'ñ'='n'
  'ò'='o' 'ó'='o' 'ô'='o' 'õ'='o' 'ö'='o' 'ø'='o' 'ù'='u' 'ú'='u' 'û'='u' 'ü'='u' 'ý'='y' 'ÿ'='y' 'Ā'='A'
  'ā'='a' 'Ă'='A' 'ă'='a' 'Ą'='A' 'ą'='a' 'Ć'='C' 'ć'='c' 'Ĉ'='C' 'ĉ'='c' 'Ċ'='C' 'ċ'='c' 'Č'='C' 'č'='c'
  'Ď'='D' 'ď'='d' 'Đ'='D' 'đ'='d' 'Ē'='E' 'ē'='e' 'Ĕ'='E' 'ĕ'='e' 'Ė'='E' 'ė'='e' 'Ę'='E' 'ę'='e' 'Ě'='E'
  'ě'='e' 'Ĝ'='G' 'ĝ'='g' 'Ğ'='G' 'ğ'='g' 'Ġ'='G' 'ġ'='g' 'Ģ'='G' 'ģ'='g' 'Ĥ'='H' 'ĥ'='h' 'Ħ'='H' 'ħ'='h'
  'Ĩ'='I' 'ĩ'='i' 'Ī'='I' 'ī'='i' 'Ĭ'='I' 'ĭ'='i' 'Į'='I' 'į'='i' 'İ'='I' 'ı'='i' 'Ĳ'='IJ' 'ĳ'='ij' 'Ĵ'='J'
  'ĵ'='j' 'Ķ'='K' 'ķ'='k' 'Ĺ'='L' 'ĺ'='l' 'Ļ'='L' 'ļ'='l' 'Ľ'='L' 'ľ'='l' 'Ŀ'='L' 'ŀ'='l' 'Ł'='L' 'ł'='l'
  'Ń'='N' 'ń'='n' 'Ņ'='N' 'ņ'='n' 'Ň'='N' 'ň'='n' 'ŉ'='n' 'Ō'='O' 'ō'='o' 'Ŏ'='O' 'ŏ'='o' 'Ő'='O' 'ő'='o'
  'Œ'='OE' 'œ'='oe' 'Ŕ'='R' 'ŕ'='r' 'Ŗ'='R' 'ŗ'='r' 'Ř'='R' 'ř'='r' 'Ś'='S' 'ś'='s' 'Ŝ'='S' 'ŝ'='s' 'Ş'='S'
  'ş'='s' 'Š'='S' 'š'='s' 'Ţ'='T' 'ţ'='t' 'Ť'='T' 'ť'='t' 'Ŧ'='T' 'ŧ'='t' 'Ũ'='U' 'ũ'='u' 'Ū'='U' 'ū'='u'
  'Ŭ'='U' 'ŭ'='u' 'Ů'='U' 'ů'='u' 'Ű'='U' 'ű'='u' 'Ų'='U' 'ų'='u' 'Ŵ'='W' 'ŵ'='w' 'Ŷ'='Y' 'ŷ'='y' 'Ÿ'='Y'
  'Ź'='Z' 'ź'='z' 'Ż'='Z' 'ż'='z' 'Ž'='Z' 'ž'='z' 'ſ'='s' 'ƒ'='f' 'Ơ'='O' 'ơ'='o' 'Ư'='U' 'ư'='u' 'Ǎ'='A'
  'ǎ'='a' 'Ǐ'='I' 'ǐ'='i' 'Ǒ'='O' 'ǒ'='o' 'Ǔ'='U' 'ǔ'='u' 'Ǖ'='U' 'ǖ'='u' 'Ǘ'='U' 'ǘ'='u' 'Ǚ'='U' 'ǚ'='u'
  'Ǜ'='U' 'ǜ'='u' 'Ǻ'='A' 'ǻ'='a' 'Ǽ'='AE' 'ǽ'='ae' 'Ǿ'='O' 'ǿ'='o' '&'='e' ' '='_' '-'='_'
)


function namefix(){
    local filename="$1"
    local fixedname=$(echo "$filename" | tr '[:upper:]' '[:lower:]')  # Converte para minúsculas usando tr
    fixedname="${fixedname//[^a-zA-Z0-9.]/_}" # Substitui caracteres especiais por _
    # retira os numero do nome do arquivo 
    fixedname=$(echo "$fixedname" | tr -d '0-9')

    for key in "${!replace_map[@]}"; do
      fixedname="${fixedname//${key}/${replace_map[$key]}}"
    done
    
    echo "${fixedname}3" | tr -s '_'  # Remove hífens extras
}

function printFormated(){
    local original="$1"
    local newname="$2"
    local current="$3"
    local total="$4"
    local percent=$((current * 100 / total))
    printf "\033[${printedLines}A"  # Move cursor up
    printf "[%-50s] %3d%%\n" "$(printf '%*s' $((percent / 2)) '' | tr ' ' '=')" "$percent"
    printf "[\033[38;5;124m%s\033[0m]\033[K\n" "$original"
    printf "[\033[38;5;46m%s\033[0m]\033[K\n" "$newname"
    printedLines=3
}

function rename(){
    local original="$1"
    local newname="$2"
    if [[ debug -eq 1 ]]; then
        echo "Debug: Renaming $original to $newname"
        ((printedLines++))  # Increment printed lines
    else
        mv -n "$original" "$newname"
    fi
}

# Main processing
echo "Starting renaming process..."
total_files=$(ls *.mp3 | wc -l)
current_file=0

for f in *.mp3; do
    ((current_file++))
    newname=$(namefix "$f")
    printFormated "$f" "$newname" "$current_file" "$total_files"
    rename "$f" "$newname"
done

printf "\033[${printedLines}A"  # Move cursor up
printf "[==================================================] 100%\033[K\n"
printf "[done]\033[K\n"
printf "[total files renamed %d]\033[K\n" "$total_files"
printf "\nRenaming completed.\033[K\n"
