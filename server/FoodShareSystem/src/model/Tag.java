package model;

/**
 * Tag entity. @author MyEclipse Persistence Tools
 */

public class Tag implements java.io.Serializable {

	// Fields

	private String tagname;

	// Constructors

	/** default constructor */
	public Tag() {
	}

	/** full constructor */
	public Tag(String tagname) {
		this.tagname = tagname;
	}

	// Property accessors

	public String getTagname() {
		return this.tagname;
	}

	public void setTagname(String tagname) {
		this.tagname = tagname;
	}

}