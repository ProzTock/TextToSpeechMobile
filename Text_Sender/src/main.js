const Realm = require("realm");
const prompt = require('prompt-sync')({sigint: true});

main();

function main(){

    const REALM_APP_ID = "text_to_speech_mobile-cctth";
    const USERNAME = "Text Sender";

    login(REALM_APP_ID, USERNAME);
}

async function login(realm_app_id, username) {

    const app = new Realm.App({ id: realm_app_id });
    const credentials = Realm.Credentials.function({ username: username});

    try{
        const user = await app.logIn(credentials);
        typeMessage(user);
    } catch(err){
        console.error("Failed to log in", err);
    }
}

async function typeMessage(user_instance){

    let message = "";

    while(true){

        console.log("\n--------------------------------\n")

        message = prompt("What's your message?: -> ");

        if(message !== "exit" && message !== "salir"){

            console.log()

            try{
                const result = await user_instance.functions.sendMessage(message);
                console.log(result);
            }catch(err){
                console.log(err.message);
            }
        }
        else{
            break;
        }
    }

    process.exit(0);
}