package servlet;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import staticUnit.GenerateRandomString;

public class UploadPicture extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public UploadPicture() {
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
		PrintWriter out = response.getWriter();
		
		String contenttype = request.getHeader("Content-Type");
		String namecontent = contenttype.split(";")[1];
		String picture_name = namecontent.split("=")[1];
		ServletInputStream sis = request.getInputStream();
		//int length = request.getContentLength();
		
		//BufferedReader br = request.getReader();
		//String content = "";
		//String line;
		/*byte [] tb = new byte[1000];
		byte [] b = new byte[100000];
		while((sis.read(tb))!=0)
		{
			//content+=line;
		}*/
		//byte[] b= new byte[length];
		
		//sis.read(b);
		
		//System.out.println(length);
		//ByteArrayInputStream in= new ByteArrayInputStream(b);
		DataOutputStream dos = new DataOutputStream(new FileOutputStream(new File("../webapps/FoodShareSystem/image/"+picture_name+".jpg")));
    	//DataInputStream dis = new DataInputStream(in); 
		int b;
		while((b=sis.read())!=-1)
		{
		dos.write(b);
		}
		//dos.writeBytes(content);
    	dos.close();
    	//BufferedImage image = ImageIO.read(in);
    	
    	
    	
    	
    	/*File file = new File("../webapps/FoodShareSystem/image/"+picture_name+".png");
    	if(!file.exists())
    		ImageIO.write(image, "png", file);
    	in.close();*/
    	
    	out.write("ok");
    	System.out.println("ok");
		out.flush();
		out.close();
	}

}
