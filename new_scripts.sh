
for a_file in $(ls ./$1/scripts)
do
  out_dir="./new_scripts/$1"

  mkdir -pv "$out_dir"
  cp './docs/templates/script.sh' "$out_dir/$a_file"
done
