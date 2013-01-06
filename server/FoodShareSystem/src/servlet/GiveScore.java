package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import staticUnit.DBOperation;

import model.Food;

public class GiveScore extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public GiveScore() {
		super();
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
		
		int foodid = Integer.parseInt(request.getParameter("foodid"));
		double oldscore = Double.parseDouble(request.getParameter("oldscore"));
		double newscore = Double.parseDouble(request.getParameter("newscore"));
		boolean ifgive = Boolean.parseBoolean(request.getParameter("ifgive"));
		
		Food food = DBOperation.GetOneFood(foodid);
		double foodscore = food.getScore();
		double totalscore = foodscore*food.getLikenumber();
		
		DecimalFormat df = new DecimalFormat("0.0");
		
		if(oldscore!=0)
		{
			double d = (totalscore - oldscore + newscore)/food.getLikenumber();
			String newfoodscorestr = df.format(d);
			double newfoodscore = Double.parseDouble(newfoodscorestr);
			System.out.println(newfoodscore);
			DBOperation.ChangeScore(foodid, newfoodscore);
			//System.out.println("true");
		}
		else
		{
			double d = (totalscore - oldscore + newscore)/(food.getLikenumber()+1);
			String newfoodscorestr = df.format(d);
			double newfoodscore = Double.parseDouble(newfoodscorestr);
			System.out.println(newfoodscore);
			DBOperation.ChangeScore(foodid, newfoodscore);
			DBOperation.ChangeLike(foodid, food.getLikenumber()+1);
			//System.out.println(food.getLikenumber()+1);
		}
		
		
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
		
		
	}

}
