const app = require('express')();
const {Server} = require('socket.io');

async function server(){
    const http = require('http').createServer(app);
    const io = new Server(http, {transports: ['websocket']});
    var roomName = 'dogfoot';
    var emettor=null;
    io.on('connection', (socket) => {
       socket.on('join', (profile) =>{
           //var tab = []
          // console.log(profile.length)
           
         if(profile.length === 2){
            roomName = profile[1].number;
            emettor=profile[0];
                                    //socket.to(roomName).emit('youHaveACall', emettor);

                        /*
                                    console.log(`Room is ${roomName}`);
                                    console.log('emettor');
                                console.log(`that is my profile ! ${profile[0].number}`);
                                console.log(`that is my profile ! ${profile[0].name}`);
                                console.log(`that is my profile ! ${profile[0].img}`);

                                console.log('receptor');
                                console.log(`that is my profile ! ${profile[1].number}`);
                                console.log(`that is my profile ! ${profile[1].name}`);
                                console.log(`that is my profile ! ${profile[1].img}`);
                                
                                */
           
         }  
         else{
            roomName = profile[0].number;
            
           // console.log(`emettor is ${emettor.number}`);
            console.log(`Room is ${roomName}`);
            console.log(`that is my profile ! ${profile[0].number}`);
           console.log(`that is my profile ! ${profile[0].name}`);
           console.log(`that is my profile ! ${profile[0].img}`);
         }
          
         socket.join(roomName);
        // socket.to(roomName).emit('youHaveACall', );
        socket.to(roomName).emit('youhavecall', {emett : emettor});
       
    
         socket.to(roomName).emit('joined', {emett : emettor});
       });
      
      
       socket.on('offer', (offer) => {
           socket.to(roomName).emit('offer', offer);
        });
        socket.on('answer', (answer) => {
            socket.to(roomName).emit('answer', answer);
        });
        socket.on('ice', (ice) => {
            socket.to(roomName).emit('ice', ice);
        });

    });
    http.listen(3000, () => console.log('server open !!'));
}

server();