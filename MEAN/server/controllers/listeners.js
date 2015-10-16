var needle = require('needle');

module.exports = (function (){
    return {
        //update broadcaster, update db
        join : function(data,socket,io){
            console.log("got join");

            post_data = {
                data : data
            };
            var options = {
                headers : {
                    'content-type' : 'application/x-www-form-urlencoded',
                    'accept' : 'application/json'
                }
            };
            console.log("sending to room " + data.user_id);
            io.to(data.user_id).emit("/testing");

            if (io.to(data.broadcaster_id)){
                console.log("broadcaster is connected");
                console.log("joining socket " + socket.id + " to broadcast:" + data.broadcast_id);
                socket.join("broadcast:" + data.broadcast_id);
                io.to(data.broadcaster_id).emit('/new_listener');
                needle.post("http://192.168.1.102:3000" + "/listeners/create", post_data, options, function (err, resp){
                    console.log("sent to db");
                });
            }else{
                console.log("broadcaster is not connected");
            }
        },

        //check if broadcaster is connected if so
        //pass along request to broadcaster
        //if not update the listener
        request_playback_info : function(data,socket,io){
            console.log("got request playback info");
            console.log("playlist_id =  " + data.playlist_id);
            if (io.sockets.sockets[data.broadcaster_id]){
                console.log("Broadcaster socket is connected?");
                io.sockets.socket(data.broadcaster_id).emit('/request_playback_info', data);
            }else{
                socket.emit('/no_broadcaster');
            }
        },
        //update broadcaster and update db
        like_track : function (data,socket,io){

        }
    };
})();