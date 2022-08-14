gens = $(nix-env --list-generations)

oldest = $(echo ${gens} | head | tr -s ' ')
o_date = $(echo ${oldest} | cut -d ' ' -f 3)
o_time = $(echo ${oldest} | cut -d ' ' -f 4)
o_ts = "${o_date}T${o_time}"

current = $(echo ${gens} | tail | tr -s ' ')
c_date = $(echo ${current} | cut -d ' ' -f 3)
c_time = $(echo ${current} | cut -d ' ' -f 4)
c_ts = "${c_date}T${c_time}"

if [[ ${o_ts} == ${c_ts} ]]; then
  exit
fi


