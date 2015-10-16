var User = require('./../models/user.js');
var Playlist = require('./../models/playlist.js');

module.exports = (function(){
    return {
        login : function (req,res,db){
            var data = req.body;
            console.log(data);
            var username = data['username'];
            var password = data['password'];
            var pass_conf = data['password_confirmation'];

            User.get_user(db,username, function (user){
                if (user){
                    if (password == user.password){
                        User.get_playlist_id(db, user.id, function(playlist_id){
                            if (playlist_id){
                                res.json({
                                    "user_id" : user.id,
                                    "username" : user.username,
                                    "playlist_id" : playlist_id
                                });
                            }else{
                                res.json({
                                    "error" : "DB error : could not retrieve playlist id"
                                });
                            }
                        });
                    }else{
                        res.json({
                            "error" : "Username taken"
                        });
                    }
                }else{
                    if (password == pass_conf){
                        User.create_user(db,username,password, function (user_id){
                            if (user_id){
                                Playlist.create_playlist(db,user_id, function (playlist_id){
                                    if (playlist_id){
                                        res.json({
                                            "user_id" : user_id,
                                            "username" : username,
                                            "playlist_id" : playlist_id
                                        });
                                    }else{
                                        res.json({
                                            "error" : "error: DB error : could not create playlist"
                                        });
                                    }
                                });
                            }else{
                                res.json({
                                    "error" : "error : DB error : could not create user"
                                });
                            }
                        });
                    }else{
                        res.json({
                            "error" : "Passwords do not match"
                        });
                    }
                }
            });
        }
    };
})();