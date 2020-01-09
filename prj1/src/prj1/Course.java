package prj1;

import javax.persistence.*;

@Entity
@Table(name = "courses")
public class Course {
	@Id
	@GeneratedValue
	@Column(name = "id_course")
	private int id;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "number_of_hours")
	private int number_of_hours;
	
	@Column(name = "value")
	private int value;
	
	@Column(name = "graduation_diploma")
	private boolean graduation_diploma;
	
	@Column(name = "year")
	private int year;
	
	@ManyToOne
	@JoinColumn(name = "id_employee")
	private Employee employee;

	public Course() {
	}

	public Course(String name, int number_of_hours, int value, boolean graduation_diploma, int year,
			Employee employee) {
		super();
		this.name = name;
		this.number_of_hours = number_of_hours;
		this.value = value;
		this.graduation_diploma = graduation_diploma;
		this.year = year;
		this.employee = employee;
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

	public int getNumber_of_hours() {
		return number_of_hours;
	}

	public void setNumber_of_hours(int number_of_hours) {
		this.number_of_hours = number_of_hours;
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		this.value = value;
	}

	public boolean isGraduation_diploma() {
		return graduation_diploma;
	}

	public void setGraduation_diploma(boolean graduation_diploma) {
		this.graduation_diploma = graduation_diploma;
	}

	public int getYear() {
		return year;
	}

	public void setYear(int year) {
		this.year = year;
	}

	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}

	@Override
	public String toString() {
		return "Course [id=" + id + ", name=" + name + ", number_of_hours=" + number_of_hours + ", value=" + value
				+ ", graduation_diploma=" + graduation_diploma + ", year=" + year + ", employee=" + employee + "]";
	}
}