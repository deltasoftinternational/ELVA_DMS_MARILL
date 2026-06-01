var version = '0.01';
var debugmode = false;


function Ping(ms) {
    if (ms > 0) {
        setTimeout(function () { RequestPong(); }, ms);        
    }
}

function RequestPong() {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('Pong');
}