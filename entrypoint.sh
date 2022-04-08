#! /bin/bash
input=$(mktemp)
output=$(mktemp)

cat > ${input}

if grep -q -m 1 '^_atom_site' ${input}; then
    # CIF to PDB
    mode=2
else
    # PDB to CIF
    mode=1
fi

maxit -input ${input} -output ${output} -o ${mode}
cat ${output}
rm ${input} ${output}
