package model;

/**
 * FoodTagId entity. @author MyEclipse Persistence Tools
 */

public class FoodTagId implements java.io.Serializable {

	// Fields

	private Integer foodid;
	private String tagname;

	// Constructors

	/** default constructor */
	public FoodTagId() {
	}

	/** full constructor */
	public FoodTagId(Integer foodid, String tagname) {
		this.foodid = foodid;
		this.tagname = tagname;
	}

	// Property accessors

	public Integer getFoodid() {
		return this.foodid;
	}

	public void setFoodid(Integer foodid) {
		this.foodid = foodid;
	}

	public String getTagname() {
		return this.tagname;
	}

	public void setTagname(String tagname) {
		this.tagname = tagname;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof FoodTagId))
			return false;
		FoodTagId castOther = (FoodTagId) other;

		return ((this.getFoodid() == castOther.getFoodid()) || (this
				.getFoodid() != null && castOther.getFoodid() != null && this
				.getFoodid().equals(castOther.getFoodid())))
				&& ((this.getTagname() == castOther.getTagname()) || (this
						.getTagname() != null && castOther.getTagname() != null && this
						.getTagname().equals(castOther.getTagname())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getFoodid() == null ? 0 : this.getFoodid().hashCode());
		result = 37 * result
				+ (getTagname() == null ? 0 : this.getTagname().hashCode());
		return result;
	}

}