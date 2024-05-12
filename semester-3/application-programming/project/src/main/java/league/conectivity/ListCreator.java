package league.conectivity;

import league.types.SimplePlayer;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

interface ListCreator <ListType> {
    void addToList(ResultSet resultSet, LinkedList<ListType> resultList) throws SQLException;
}
