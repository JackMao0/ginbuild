read -p 'Enter your username, then hit [ENTER]: ' USERNAME
sudo apt-get -y install node.js
sudo apt-get -y install npm
curl -s https://fibos.io/download/installer.sh |sh

#fibos --init
npm install fibos.js
rm createAccount.js
cat <<EOT >> createAccount.js
var FIBOS = require("fibos.js");
var fs = require('fs');
var prikey = FIBOS.modules.ecc.randomKeySync(); 
var pubkey = FIBOS.modules.ecc.privateToPublic(prikey); 
var http = require('http');
var httpClient = new http.Client();
var httpServerHost = "http://tunnel.fibos.io/1.0/app/token/create";

var account = "{UN}" 


var rep = httpClient.post(httpServerHost, {
            json: {
                    account: account,
                    pubkey: pubkey
            }
}).json()
console.log(rep);
fs.appendFile('./message.txt',"message:"+rep.message+'\r\n'+"prikey:" + prikey+'\r\n'+"pubkey:" + pubkey+'\r\n');
fs.appendFile('./message.txt',"-----------------------------------"+'\r\n');
//fs.appendFile('./message.txt',"prikey:" + prikey);
//fs.appendFile('./message.txt',"pubkey:" + pubkey);
EOT


sed -i -e "s/{UN}/$USERNAME/g" createAccount.js

fibos createAccount.js