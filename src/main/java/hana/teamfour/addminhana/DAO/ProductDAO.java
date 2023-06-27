package hana.teamfour.addminhana.DAO;

import hana.teamfour.addminhana.entity.ProductEntity;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ProductDAO {
    private DataSource dataFactory;

    public ProductDAO() {
        try {
            Context ctx = new InitialContext();
            Context envContext = (Context) ctx.lookup("java:/comp/env");
            dataFactory = (DataSource) envContext.lookup("jdbc/oracle");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ArrayList<ProductEntity> getProduct(Integer id, String productType, String _sql) {
        ArrayList<ProductEntity> productList = new ArrayList<>();

        try (Connection connection = dataFactory.getConnection();
             PreparedStatement statement = connection.prepareStatement(_sql)){

            statement.setInt(1, id);
            statement.setString(2, productType);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ProductEntity productEntity = new ProductEntity();
                    productEntity.setP_id(resultSet.getInt(1));
                    productEntity.setP_name(resultSet.getString(2));
                    productEntity.setP_interestrate(resultSet.getDouble(3));
                    productEntity.setP_limit(resultSet.getInt(4));
                    productList.add(productEntity);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productList;
    }

    public ArrayList<ProductEntity> findByID(Integer id, String productType) {
        // 가입한 product id list 반환
        String sql = "select pro.p_id, pro.p_name, pro.p_interestrate, pro.p_limit " +
                "from account acc, product pro " +
                "where acc.acc_pid = pro.p_id and acc.acc_cid = ? and substr(pro.p_category, 3, 2) = ?";
        ArrayList<ProductEntity> productList = getProduct(id, productType, sql);
        return productList;
    }

    public ArrayList<ProductEntity> findNotJoined(Integer id, String productType) {
        // 가입하지 않은 product list 반환
        String sql = "select pro.p_id, pro.p_name, pro.p_interestrate, pro.p_limit " +
                "from account acc, product pro " +
                "where acc.acc_pid = pro.p_id and acc.acc_cid <> ? and substr(pro.p_category, 3, 2) = ?";
        ArrayList<ProductEntity> productList = getProduct(id, productType, sql);
        return productList;
    }
}
