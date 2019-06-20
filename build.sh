rm -r docs/extensions/alpino_plus/package.xml ;
rm -r docs/extensions/alpino_plus.zip ;
rm -r docs/extensions/.DS_Store ;
cp docs/src/package.xml docs/extensions/alpino_plus/ ;
cd docs/src; 
zip -r ../extensions/alpino_plus.zip . -x "*.DS_Store"; 
cd ../..;