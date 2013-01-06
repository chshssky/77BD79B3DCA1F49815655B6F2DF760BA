package model;

/**
 * Food entity. @author MyEclipse Persistence Tools
 */

public class Food implements java.io.Serializable {

	// Fields

	private Integer foodid;
	private String foodname;
	private String imagename;
	private Double price;
	private Double score;
	private Integer likenumber;
	private String restaurantname;
	private String submittime;

	// Constructors

	/** default constructor */
	public Food() {
	}

	/** minimal constructor */
	public Food(Integer foodid) {
		this.foodid = foodid;
	}

	/** full constructor */
	public Food(Integer foodid, String foodname, String imagename,
			Double price, Double score, Integer likenumber,
			String restaurantname, String submittime) {
		this.foodid = foodid;
		this.foodname = foodname;
		this.imagename = imagename;
		this.price = price;
		this.score = score;
		this.likenumber = likenumber;
		this.restaurantname = restaurantname;
		this.submittime = submittime;
	}

	// Property accessors

	public Integer getFoodid() {
		return this.foodid;
	}

	public void setFoodid(Integer foodid) {
		this.foodid = foodid;
	}

	public String getFoodname() {
		return this.foodname;
	}

	public void setFoodname(String foodname) {
		this.foodname = foodname;
	}

	public String getImagename() {
		return this.imagename;
	}

	public void setImagename(String imagename) {
		this.imagename = imagename;
	}

	public Double getPrice() {
		return this.price;
	}

	public void setPrice(Double price) {
		this.price = price;
	}

	public Double getScore() {
		return this.score;
	}

	public void setScore(Double score) {
		this.score = score;
	}

	public Integer getLikenumber() {
		return this.likenumber;
	}

	public void setLikenumber(Integer likenumber) {
		this.likenumber = likenumber;
	}

	public String getRestaurantname() {
		return this.restaurantname;
	}

	public void setRestaurantname(String restaurantname) {
		this.restaurantname = restaurantname;
	}

	public String getSubmittime() {
		return this.submittime;
	}

	public void setSubmittime(String submittime) {
		this.submittime = submittime;
	}

}