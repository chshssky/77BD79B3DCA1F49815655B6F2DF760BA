package staticUnit;

import java.util.List;

import model.Food;
import model.FoodTag;
import model.Restaurant;
import model.Telephone;


public class GenerateXMLData {
	static public String GenerateFoodListXML(List<Food> list,int fromid, int toid)
	{
		String result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
		"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"+
		"<plist version=\"1.0\">";
				//"<body>";
		result+="<array>";
		
		for(Food f:list)
		{
			if(f.getFoodid()>fromid&&f.getFoodid()<toid)
			{
				//result+="<food>";
				result+="<dict>";
				//result+="<foodname>"+f.getId().getFoodname()+"</foodname>";
				result+="<key>名称</key>";
				result+="<string>"+f.getFoodname()+"</string>";
				result+="<key>评分</key>";
				result+="<string>"+f.getScore()+"</string>";
				//result+="<foodscore>"+f.getId().getScore()+"</foodscore>";
				//result+="<foodtime>"+f.getId().getTime()+"</foodtime>";
				result+="<key>上传时间</key>";
				result+="<string>"+f.getSubmittime()+"</string>";
				result+="<key>图片</key>";
				result+="<string>"+f.getImagename()+"</string>";
				
				result+="<key>价格</key>";
				result+="<string>"+f.getPrice()+"</string>";
				result+="<key>美食标签</key>";
				result+="<array>";
				List<FoodTag> taglist = DBOperation.QueryDB("from FoodTag where foodid="+f.getFoodid());
				for (FoodTag foodtag :taglist)
				{
					result+="<string>"+foodtag.getId().getTagname()+"</string>";
				}
				result+="</array>";
				result+="<key>餐馆</key>";
				result+="<dict>";
				result+="<key>名称</key>";
				result+="<string>"+f.getRestaurantname()+"</string>";
				Restaurant restaurant = DBOperation.GetOneRestaurant(f.getRestaurantname());
				result+="<key>餐馆ID</key>";
				result+="<string>"+restaurant.getRestaurantid()+"</string>";
				result+="<key>电话</key>";
				result+="<array>";
				
				List<Telephone> tellist = DBOperation.QueryDB("from Telephone where restaurantid="+restaurant.getRestaurantid());
				for(Telephone tel:tellist)
				{
					result+="<string>"+tel.getPhonenumber()+"</string>";
				}
				result+="</array>";
				result+="</dict>";
				//result+="</food>";
				result+="</dict>";
				
			}
			else
				break;
		}
		result+="</array></plist>";
		//result+="</body>";
		System.out.println(result);
		return result;
	}
	
	static public String GenerateRestaurantXML()
	{
		String result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
				"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"+
				"<plist version=\"1.0\">";
		result+="<array>";
		
		List<Restaurant> restlist = DBOperation.QueryDB("from Restaurant"); 
		
		for(Restaurant rest:restlist)
		{
			result+="<dict>";
			result+="<key>餐馆名称</key>";
			result+="<string>"+rest.getRestaurantname()+"</string>";
			//ystem.out.println(rest.getRestaurantname());
			result+="<key>电话</key>";
			result+="<array>";
			List<Telephone> tellist = DBOperation.QueryDB("from Telephone where restaurantid="+rest.getRestaurantid());
			for(Telephone tel:tellist)
			{
				result+="<string>"+tel.getPhonenumber()+"</string>";
			}
			result+="</array>";
			result+="</dict>";
		}
		
		result+="</array></plist>";
		return result;
	}
	
	
	static public String GenerateDetailXML(Food food)
	{
		String result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
				"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"+
				"<plist version=\"1.0\">";
		
		
		List<FoodTag> list = DBOperation.QueryDB("from FoodTag where foodid="+food.getFoodid());
		
		result+="<dict>";
		result+="<key>Name</key>";
		result+="<string>"+food.getFoodname()+"</string>";
		result+="<key>Tags</key>";
		result+="<array>";
		for (FoodTag tag :list)
		{
			result+="<string>"+tag.getId().getTagname()+"</string>";
		}
		result+="</array>";
		result+="</dict>";
		
		result+="</plist>";
		return result;
	}
	
	/*static public String GenerateTagXML(List<Taginfo> list)
	{
		String result = "";
		
		return result;
	}*/
	
	static public String test()
	{
		String result = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+
				"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"+
				"<plist version=\"1.0\">";
						//"<body>";
				result+="<dict>";
				int size = 10;
				
				result+="<key>Tag</key>"+
						"<array>"+
						"<string>zhongkouwei</string>"+
						"<string>xiaoqingxin</string>"+
						"</array>"+
						"<key>Name</key>"+
						"<string>test</string>";
				
				/*for(Foodinfo f:list)
				{
					if(size>0&&f.getId().getFoodid()>id)
					{
						result+="<food>";
						//result+="<key>";
						result+="<foodname>"+f.getId().getFoodname()+"</foodname>";
						result+="<foodscore>"+f.getId().getScore()+"</foodscore>";
						result+="<foodtime>"+f.getId().getTime()+"</foodtime>";
						result+="</food>";
						size--;
					}
					else
						continue;
				}*/
				result+="</dict></plist>";
				//result+="</body>";
				
				return result;
		
	}
}
