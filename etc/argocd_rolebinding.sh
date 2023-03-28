!/bin/bash
x=1
while [ $x -le 35 ]
do
  namespace="edu${x}"
  echo $namespace
  k_exec=`kubectl create clusterrolebinding argocd-rolebinding${x} --clusterrole=argocd-role --user=${namespace}-admin`
  echo $k_exec
  sleep 1
  x=$(( $x + 1 ))
done
