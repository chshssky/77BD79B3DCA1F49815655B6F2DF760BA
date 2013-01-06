package model;

/**
 * FoodTag entity. @author MyEclipse Persistence Tools
 */

public class FoodTag implements java.io.Serializable {

	// Fields

	private FoodTagId id;

	// Constructors

	/** default constructor */
	public FoodTag() {
	}

	/** full constructor */
	public FoodTag(FoodTagId id) {
		this.id = id;
	}

	// Property accessors

	public FoodTagId getId() {
		return this.id;
	}

	public void setId(FoodTagId id) {
		this.id = id;
	}

}