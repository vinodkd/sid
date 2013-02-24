function set_testdata()
{
  declare -a dirs
  dirs=( . ../dogfood )
  local i=0
  for dir in ${dirs[*]}
  do
    # the ? prevents pickup of the sid script itself
    for script in $dir/*arch
    do
      TEST_DATA[$i]=$script
      let "i = $i + 1"
    done
  done
}

function setup()
{
  echo setup done
}

function teardown()
{
  filename=${inp%.*}
  echo $filename
  
}
