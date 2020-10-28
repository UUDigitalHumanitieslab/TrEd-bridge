echo "deleting old extensions from ssh home folder.." ;
ssh -t im-dhstatic "sudo rm -r extensions;"
echo "copying extensions to server.." ;
scp -r dist/extensions im-dhstatic: ;
echo "running server deploy script.." ;
ssh -t im-dhstatic "sudo bash deploy_tred.sh";
echo "done!"
