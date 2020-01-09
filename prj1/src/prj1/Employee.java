package prj1;

import java.util.Set;
import javax.persistence.*;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

@Entity
@Table(name = "Employees")
class Employee {
	@Id
	@Column(name = "id")
	private int id;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "firm")
	private String firm;
	
	@Column(name = "position")
	private String position;
	
	@Column(name = "date_of_employment")
	private String date_of_employment;
	
	@OneToMany(mappedBy = "employee")
	@Cascade(CascadeType.ALL)
	private Set<Course> courses;

	public Employee() {
	}

	public Employee(int id, String name, String firm, String position, String date_of_employment) {
		super();
		this.id = id;
		this.name = name;
		this.firm = firm;
		this.position = position;
		this.date_of_employment = date_of_employment;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFirm() {
		return firm;
	}

	public void setFirm(String firm) {
		this.firm = firm;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getDate_of_employment() {
		return date_of_employment;
	}

	public void setDate_of_employment(String date_of_employment) {
		this.date_of_employment = date_of_employment;
	}

	public Set<Course> getCourses() {
		return courses;
	}

	public void setCourses(Set<Course> courses) {
		this.courses = courses;
	}

	@Override
	public String toString() {
		return "Employee [id=" + id + ", name=" + name + ", firm=" + firm + ", position=" + position
				+ ", date_of_employment=" + date_of_employment + "]";
	}
}