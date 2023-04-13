// Use this sample to create your own voice commands
intent('hello world', p => {
    p.play('(hello|hi there)');
});

intent('play','play (the|some|) music', p => {
    p.play({"command":"play"});
    p.play("(Playing Now| Sure| Doing it right now)");
});

intent('play $(CHANNEL* (.*)) fm', p => {
    let channel = project.radios.filter(x=> x.name.toLowerCase() === p.CHANNEL.value.toLowerCase())[0]; 
    try{
       p.play({"command":"play_channel", "id": channel.id});
       p.play('(Playing Now|on it|Ok boss|Doing it)'); 
    }catch(err){
        console.log("Can't play");
        p.play("I cannot play this");
    }
});

intent('pause','pause (the|) music','alan stop','alan pause (the|) music', p => {
    p.play({"command":"stop"});
    p.play("(stopping Now| Sure| Doing it right now|Pause)");
});

intent('(play|) next (channel|fm|radio|)', p => {
    p.play({"command":"next"});
    p.play("(on it| Sure| Doing it right now|Playing now)");
});

intent('(play|) previous (channel|fm|radio|)', p => {
    p.play({"command":"prev"});
    p.play("(on it boss| Sure| Doing it right now|Playing now)");
});

// Give Alan some knowledge about the world
corpus(`
    Hello, I'm Alan.
    This is a demo application.
    You can learn how to teach Alan useful skills.
    I can teach you how to write Alan Scripts.
    I can help you. I can do a lot of things. I can answer questions. I can do tasks.
    But they should be relevant to this application.
    I can help with this application.
    I'm Alan. I'm a virtual assistant. I'm here to help you with applications.
    This is a demo script. It shows how to use Alan.
    You can create dialogs and teach me.
    For example: I can help navigate this application.
`);
