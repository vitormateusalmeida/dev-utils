#!/usr/bin/node
/*
  Author: Tainan Felipe
  Note: You should change the binry path in the start of the file if your node binary isn't a default installation
*/
const { exec } = require("child_process");


const argv = process.argv.slice(2);
/*
remoteURL: server domain that hosts the application
sysTool: choose between iptables or conntrack
protocol: tcp, udp or both
time: time in miliseconds after sysRule be executed
*/
const [ remoteURL, sysTool, protocol, time ] = argv;

const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout
});

// promisify the exec function
async function execPromise(command){
  const result = await new Promise((res, rej) =>{
    exec(command, (err,stdout,stdrr)=>{
      res({
        err,
        stdout,
        stdrr
      });
    });
  });
  return result;
}

//sleep for N miliseconds
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}


// promisify the readline function
async function promisifyReadline(message){
  const result = await new Promise((res, rej) =>{
    readline.question(message, input => {
      res(input);
      readline.close();
    });
  });
  return result;
}

// get the server ip based in the client domain
async function getServerIP(URL){
  const {err, stdout, stdrr } = await execPromise(`ping -c 1 ${URL}`);
  if (err) {
    console.log('err',err)
    process.abort();
  }
  const getRemoteIP = stdout.split(' ')[2];
  const remoteIPWithouParentesis = getRemoteIP.slice(1, getRemoteIP.length-1);
  return remoteIPWithouParentesis;
}

// get the value of rule nf_conntrack_tcp_loose
// default value is 1
async function getConntrackTCPLoose() {
  const {err, stdout, stdrr } = await execPromise(`sudo cat /proc/sys/net/netfilter/nf_conntrack_tcp_loose`);
  return stdout;
}


// Change the rule to disable picking up already established connections.
async function changeConntrackTCPLoose(num){
  // num should be 1 or 0
  const {err, stdout, stdrr } = await execPromise(`sudo sysctl -w net.netfilter.nf_conntrack_tcp_loose=${num}`);
  if(err){
    console.log('err: ', err);
    process.abort();
  }
  return 0;
}

// set the iptables registry for the given server ip
async function setIptables(remoteIp, protocol, addOrRemove){
  const inclusionOrDeletion = addOrRemove == 'ADD' ? '-I' : '-D';
  const command = `sudo iptables ${inclusionOrDeletion} OUTPUT -d ${remoteIp} ${protocol == 'both'? '': `-p ${protocol}`} -j DROP`;
  const {err, stdout, stdrr } = await execPromise(command);
  if(err){
    console.log('err: ', err);
    process.abort();
  }
  return 0;
}

// flush the conntrack registry for the given server ip
async function cleanConntrack(ip){
  const {err, stdout, stdrr } = await execPromise(`sudo conntrack ${protocol == 'both'? '': `-p ${protocol}`} -D -d ${ip} `);
  if(err){
    console.log('err: ', err);
    process.abort();
  }
  return 0;
}

(async function(){
  let changedTCPLooseRule = false;
  const remoteIp = await getServerIP(remoteURL);
  const conntrackTCPLoose = await getConntrackTCPLoose();

  // It'll execute if the value is equal 1
  if (Number.parseInt(conntrackTCPLoose) && sysTool == 'conntrack') {
    console.log('Changing tcp loose rule to 0')
    await changeConntrackTCPLoose(0);
    changedTCPLooseRule = true;
  }

  if (sysTool == 'conntrack'){
    console.log('Flushing conntrack for remote ip')
    await cleanConntrack(remoteIp);
  }

  if (sysTool == 'iptables'){
    console.log('Setting iptables for remote ip')
    await setIptables(remoteIp, protocol, 'ADD');
  }

  // Hold execution till user press enter
  // It's made to script user have time to explore the client state.
  if (time > 0) {
    console.log(`Hold execution for ${time} miliseconds`);
    await sleep(time);
  } else {
    const input = await promisifyReadline('Press enter to continue:');
  } 

  if(sysTool == 'iptables'){
    console.log('Removing iptables for remote ip')
    await setIptables(remoteIp, protocol, 'REMOVE');
  }
  if (changedTCPLooseRule && sysTool == 'conntrack') {
    console.log('Resetting tcp loose rule');
    await changeConntrackTCPLoose(1);
  }

  console.log('done');
  process.exit(0);

})();
