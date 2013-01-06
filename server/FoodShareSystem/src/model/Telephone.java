package model;

/**
 * Telephone entity. @author MyEclipse Persistence Tools
 */

public class Telephone implements java.io.Serializable {

	// Fields

	private String phonenumber;
	private Integer restaurantid;

	// Constructors

	/** default constructor */
	public Telephone() {
	}

	/** minimal constructor */
	public Telephone(String phonenumber) {
		this.phonenumber = phonenumber;
	}

	/** full constructor */
	public Telephone(String phonenumber, Integer restaurantid) {
		this.phonenumber = phonenumber;
		this.restaurantid = restaurantid;
	}

	// Property accessors

	public String getPhonenumber() {
		return this.phonenumber;
	}

	public void setPhonenumber(String phonenumber) {
		this.phonenumber = phonenumber;
	}

	public Integer getRestaurantid() {
		return this.restaurantid;
	}

	public void setRestaurantid(Integer restaurantid) {
		this.restaurantid = restaurantid;
	}

}