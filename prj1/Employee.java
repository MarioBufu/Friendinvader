
@Entity
class Employee {
    @id
    private int id;
    private int name;
    private String firm;
    private String position;
    private String date_of_employment;
    @OneToMany
    private Set<Course> courses;

    public Employee() {}

    public Employee(int id, int name, String firm, String position, String date_of_employment, Set<Course> courses) {
        this.id = id;
        this.name = name;
        this.firm = firm;
        this.position = position;
        this.date_of_employment = date_of_employment;
        this.courses = courses;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getName() {
        return name;
    }

    public void setName(int name) {
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

    @java.lang.Override
    public java.lang.String toString() {
        return "Employee{" +
                "name=" + name +
                ", firm='" + firm + '\'' +
                ", position='" + position + '\'' +
                '}';
    }
}