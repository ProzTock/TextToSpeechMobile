class Database{

    static instance;
    user_instance;
    realm_instance;

    constructor(user_instance, realm_instance){

        if(!!Database.instance){
            return Database.instance;
        }

        Database.instance = this;
        this.user_instance = user_instance;
        this.realm_instance = realm_instance;
    }

    deleteInstance(){
        Database.instance = undefined;
    }
}

module.exports = Database;