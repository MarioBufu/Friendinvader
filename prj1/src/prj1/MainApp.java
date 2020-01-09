package prj1;

import java.util.*;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;

public class MainApp {
	private static SessionFactory factory;

	public static void main(String[] args) {
		try {
			Configuration configuration = new Configuration();
			configuration.configure();
			StandardServiceRegistry service = new StandardServiceRegistryBuilder()
					.applySettings(configuration.getProperties()).build();
			factory = configuration.buildSessionFactory(service);
		} catch (Throwable ex) {
			System.err.println("Failed to create sessionFactory object." + ex);
			throw new ExceptionInInitializerError(ex);
		}
		Employee p1 = new Employee(1,"Mario","Conti","SW","2017");
		Set<Course> set1 = new HashSet<Course>();
		set1.add(new Course("poo",40,5,true,2018,p1));
		set1.add(new Course("mc",20,3,false,2017,p1));
		//set1.add(new Course(2004,"Berlin",3,p1));
		p1.setCourses(set1);
		add(p1);
		Employee p2 = new Employee(2,"Vlad","Nokia","SW","2016");
		Set<Course> set2 = new HashSet<Course>();
		set2.add(new Course("fimr",30,4,false,2018, p2));
		set2.add(new Course("pc",40,5,true,2017, p2));
		p2.setCourses(set2);
		add(p2);
		display();
		System.out.println("----");
		//update("John", 21);
		//delete("Daniel");
		//display();
	}

//1. Adding, searching, deleting, updating data for an employee
	public static void add(Employee emp) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(emp);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

	public static void update(String name, String firm, String position, String date_of_employment) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			List<Employee> employees = session.createQuery("FROM Employee").list();
			for (Employee emp : employees) {
				if (emp.getName().equalsIgnoreCase(name)) {
					emp.setFirm(firm);
					emp.setPosition(position);
					emp.setDate_of_employment(date_of_employment);
					session.update(emp);
					break;
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

	public static void delete(String name) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			List<Employee> employees = session.createQuery("FROM Employee").list();
			for (Employee emp : employees) {
				if (emp.getName().equalsIgnoreCase(name)) {
					session.delete(emp);
					break;
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

//2. Adding, editing, deleting, searching for a course
	public static void add(Course c) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			session.save(c);
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

	public static void update(String name, int num_of_h, int val, boolean diploma, int year) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			List<Course> courses = session.createQuery("FROM Course").list();
			for (Course c : courses) {
				if (c.getName().equalsIgnoreCase(name)) {
					c.setNumber_of_hours(num_of_h);
					c.setValue(val);
					c.setGraduation_diploma(diploma);
					c.setYear(year);
					session.update(c);
					break;
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

	public static void delete(int id) {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			List<Course> courses = session.createQuery("FROM Employee").list();
			for (Course c : courses) {
				if (c.getId() == id) {
					session.delete(c);
					break;
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

//3. Displaying all the employees of a company
	public static void display() {
		Session session = factory.openSession();
		Transaction tx = null;
		try {
			tx = session.beginTransaction();
			List<Employee> employees = session.createQuery("FROM Employee").list();
			for (Employee emp : employees) {
				System.out.println(emp);
				Set<Course> trips = emp.getCourses();
				for (Course e : trips) {
					System.out.println("-" + e);
				}
			}
			tx.commit();
		} catch (HibernateException e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}
}