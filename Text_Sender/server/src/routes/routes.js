const express = require("express");
const router = express.Router();
const Realm = require("realm");
const Database = require("../module/db.js");

router.get('/is_running', (req, res) => {

    res.send(" [+] Server is running...")
});

router.post('/login', (req, res) => {

    const { realm_app_id, username } = req.body

    async function login(){

        try{

            const app_obj = new Database();
            app_obj.deleteInstance();

            const realm_app = new Realm.App({ id: realm_app_id });
            const credentials = Realm.Credentials.function({ username: username});

            return [ await realm_app.logIn(credentials)
                .then((user) => {return user}), realm_app ];

        }catch(err){
            console.log(err.message);
        }
    }

    login()
        .then((app_info) => {
            new Database(app_info[0], app_info[1]);
            res.send(` [+] Successfully signed in ${username}...`);
        })
        .catch((err) => res.send(" [-] " + err.message));
});

router.post('/logout', (req, res) => {

    async function logout(){

        try{
            const app_obj = new Database();
            await app_obj.realm_instance.currentUser.logOut();
            app_obj.deleteInstance();
        }catch(err){
            console.log(err.message);
        }
    }

    logout()
        .then(() => res.send(` [+] Successfully logged out...`))
        .catch((err) => res.send(" [-] " + err.message));
});

router.post('/send_message', (req, res) => {

    const { message } = req.body

    async function sendingMessage(user_instance){

        try{
            const response = await user_instance.functions.sendMessage(message);
            return response;
        } catch(err){
            return err.message;
        }
    }

    const user_app = new Database().user_instance;
    sendingMessage(user_app)
        .then((result) => res.send(" [+] " + result))
        .catch((err) => res.send(" [-] " + err.message));
});

module.exports = router;