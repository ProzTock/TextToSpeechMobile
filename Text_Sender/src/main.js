const Realm = require("realm");

const REALM_APP_ID = "text_to_speech_mobile-cctth";
login(REALM_APP_ID);

async function login() {

    const app = new Realm.App({ id: REALM_APP_ID });
    const credentials = Realm.Credentials.anonymous();

    try {
        const user = await app.logIn(credentials);
    } catch(err) {
        console.error("Failed to log in", err);
    }
};