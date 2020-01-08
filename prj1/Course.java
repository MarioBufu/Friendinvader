
@Entity
class Course {
    @ManyToOne
    private Employee emp;
    @id
    private int id_course;
    private String name;
    private int number_of_hours;
    private String value;
    private boolean graduation_diploma;
    private int year;

    public Course() {}

    public Course(int id_course, String name, int number_of_hours, String value, boolean graduation_diploma, int year) {
        this.id_course = id_course;
        this.name = name;
        this.number_of_hours = number_of_hours;
        this.value = value;
        this.graduation_diploma = graduation_diploma;
        this.year = year;
    }

    public Employee getEmp() {
        return emp;
    }

    public void setEmp(Employee emp) {
        this.emp = emp;
    }

    public int getId_course() {
        return id_course;
    }

    public void setId_course(int id_course) {
        this.id_course = id_course;
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

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
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

    @Override
    public String toString() {
        return "Course{" +
                "name='" + name + '\'' +
                ", number_of_hours=" + number_of_hours +
                ", value='" + value + '\'' +
                ", graduation_diploma=" + graduation_diploma +
                ", year=" + year +
                '}';
    }
}