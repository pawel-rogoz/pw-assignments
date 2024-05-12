package league.conectivity;

import org.json.JSONObject;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import org.apache.commons.io.IOUtils;

    /*
    how to use this class:

//in imports:
import java.sql.Connection;

//in your method:
Connection con = BaseConector.getConnection();
//con is an Connection in case of success or null in case of failure

     */

class BaseConector {

    private static boolean isRead = false; //if data from resource file "connection.text" was already read
    private static String className, url, user, password;

    public static Connection getConnection(){
        /*
        returns sql Connection in case of success and null in case of failure (for example internet loss)
         */

        if(!isRead){
            if(!read()) return null;
        }

        Connection con = null;
        try {
            Class.forName(className);
            con= DriverManager.getConnection(url,user,password);
        } catch (Exception e) {
            System.out.println("The exception happened while trying to connect to database. This is exception: ");
            e.printStackTrace();
        }
        return con;
    }

    private static boolean read(){
        boolean toReturn = false;
        try(InputStream stream = BaseConector.class.getClassLoader().getResourceAsStream("connection.txt");){
            JSONObject json = new JSONObject(IOUtils.toString(stream, "UTF-8"));

            className = json.getString("className");
            url = json.getString("url");
            user = json.getString("user");
            password = json.getString("password");

            isRead = true;
            toReturn = true;
        }catch (Exception e){
            className = null; url = null; user = null; password = null;

            System.out.println("An exception happened while trying to read connection data from resource file!");
            System.out.println("This is an exception: ");
            e.printStackTrace();
        }
        return toReturn;
    }
}
