rm -r dist/extensions/alpino_plus/package.xml ;
rm -r dist/extensions/alpino_plus.zip ;
rm -r dist/extensions/.DS_Store ;
cp dist/src/package.xml dist/extensions/alpino_plus/ ;
cd dist/src; 
zip -r ../extensions/alpino_plus.zip . -x "*.DS_Store"; 
cd ../..;