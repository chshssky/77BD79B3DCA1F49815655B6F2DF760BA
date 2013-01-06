package model;

/**
 * Restaurant entity. @author MyEclipse Persistence Tools
 */

public class Restaurant implements java.io.Serializable {

	// Fields

	private Integer restaurantid;
	private String restaurantname;

	// Constructors

	/** default constructor */
	public Restaurant() {
	}

	/** minimal constructor */
	public Restaurant(Integer restaurantid) {
		this.restaurantid = restaurantid;
	}

	/** full constructor */
	public Restaurant(Integer restaurantid, String restaurantname) {
		this.restaurantid = restaurantid;
		this.restaurantname = restaurantname;
	}

	// Property accessors

	public Integer getRestaurantid() {
		return this.restaurantid;
	}

	public void setRestaurantid(Integer restaurantid) {
		this.restaurantid = restaurantid;
	}

	public String getRestaurantname() {
		return this.restaurantname;
	}

	public void setRestaurantname(String restaurantname) {
		this.restaurantname = restaurantname;
	}

}