var Playlist = require('./../models/playlist.js');
var Track = require('./../models/track.js');

module.exports = (function(){
    return{
        add_track : function (req,res,db){
            var data = req.body;
            console.log(data);
            Track.add_track (db, data, function (track){
                if (track){
                    res.json({
                        "track" : track
                    });
                }else{
                    res.json({
                        "error" : "error: DB error: could not add track"
                    });
                }
            });
        },
        get_playlist : function (req,res,db){
            var data = req.body;
            Track.all_playlist(db,data.playlist_id, function (tracks){
                if (tracks){
                    // console.log(tracks[0]);
                    Playlist.get_position(db,data.playlist_id, function (position){
                        console.log("position : " + position);
                        if (position !== null){
                            res.json({
                                "tracks" : tracks,
                                "playlist_position" : position
                            });
                        }else{
                            res.json({
                                "error" : "error: DB error: could not get playlist position"
                            });
                        }
                    });
                }else{
                    res.json({
                        "error" : "error: DB error: could not get tracks"
                    });
                }
            });
        },
        update_position : function (req,res,db){
            var data = req.body;
            console.log(data);
            Playlist.update_position(db, data.playlist_id, data.playlist_position, function (worked){
                if (worked){
                    res.json({
                        "worked" : true
                    });
                }else{
                    res.json({
                        "error" : "error: DB error: unable to update position"
                    });
                }
            });
        },
        update_broadcasting : function (req,res,db){
            var data = req.body;
            console.log(data);
            Playlist.update_broadcasting(db, data.playlist_id, data.broadcasting, function (worked){
                if (worked){
                    res.json({
                        "worked" : true
                    });
                }else{
                    res.json({
                        "error" : "error : "
                    });
                }
            });
        },
        get_all_broadcasts : function (req,res,db){
            Playlist.all_broadcasts(db, function (broadcasts){
                if (broadcasts){
                    res.json({
                        "broadcasts" : broadcasts
                    });
                }else{
                    res.json({
                        "error" : "error: DB error : could not retrieve broadcasts"
                    });
                }
            });
        }
    };
})();