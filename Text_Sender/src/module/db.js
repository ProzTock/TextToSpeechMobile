export default class Database{

    static instance;
    user_instance;
    realm_instance;

    constructor(user_instance, realm_instance){

        console.log(Database.instance)

        if(!! Database.instance){
            return Database.instance;
        }

        Database.instance = this;
        this.user_instance = user_instance;
        this.realm_instance = realm_instance;
    }

    deleteInstance(){

        Database.instance = undefined;
        //this.user_instance = undefined;
        //this.realm_instance = undefined;
    }
}