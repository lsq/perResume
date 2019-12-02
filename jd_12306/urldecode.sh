
sed -i '
  s/%7B/{/g
  s/%22/"/g
  s/%3A/:/g
  s/%2C/,/g
  s/%7D/}/g
  ' $1
