package servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import staticUnit.DBOperation;

public class PublishRestaurant extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	private HashMap wordMap;
	
	public PublishRestaurant() {
		super();
		wordMap = new HashMap();
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
		out.println("<HTML>");
		out.println("  <HEAD><TITLE>A Servlet</TITLE></HEAD>");
		out.println("  <BODY>");
		out.print("    This is ");
		out.print(this.getClass());
		out.println(", using the GET method");
		out.println("  </BODY>");
		out.println("</HTML>");
		out.flush();
		out.close();
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		request.setCharacterEncoding("utf8");
		response.setCharacterEncoding("utf8");
		PrintWriter out = response.getWriter();
		
		BufferedReader br = request.getReader();
		String line;
		while ((line = br.readLine()) != null)
		{
			this.getKeyAndValue(line);
		}
		
		String restaurantname = (String)wordMap.get("restaurant");
		String telephone = (String)wordMap.get("telephone");
		
		System.out.println(restaurantname);
		System.out.println(telephone);
		
		DBOperation.PublishTelephone(restaurantname, telephone);
		
		out.print("ok");
		
		out.flush();
		out.close();
	}
	
	private void getKeyAndValue(String content)
	{
		String[] words = content.split("=");
		String key = words[0];
		String value = words[1];
		
		wordMap.put(key, value);
		
	}

}
