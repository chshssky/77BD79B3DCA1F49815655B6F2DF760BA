package staticUnit;

import hibernate.HibernateSessionFactory;

import java.util.List;

import javax.management.Query;

import model.Food;
import model.FoodTag;
import model.FoodTagId;
import model.Restaurant;
import model.Tag;
import model.Telephone;


import org.hibernate.Session;
import org.hibernate.Transaction;

public class DBOperation {
	
	
	static public List QueryDB(String hql)
	{
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		
		List<Object> list = hs.createQuery(hql).list();
		
		tran.commit();
		HibernateSessionFactory.closeSession();
		
		return list;
		
	}
	
	static public void AddFood(String name,String imagename,double price,String restaurant,String time,String[] tag)
	{
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		
		List<Food> list = hs.createQuery("from Food").list();
		int id;
		if(list.size()!=0)
		{
			Food lastfood = list.get(list.size()-1);
			id = lastfood.getFoodid();
		}
		else
		{
			id=0;
		}
		
		Food newfood = new Food();
		
		newfood.setFoodid(id+1);
		newfood.setFoodname(name);
		newfood.setImagename(imagename);
		newfood.setPrice(price);
		newfood.setLikenumber(0);
		newfood.setScore(0.0);
		newfood.setRestaurantname(restaurant);
		newfood.setSubmittime(time);
		
		List<Tag> taglist = hs.createQuery("from Tag").list();
		
		boolean ifexist=false;
		
		if(tag!=null)
		{
			for(int j=0;j<tag.length;j++)
			{
				for(int i=0;i<taglist.size();i++)
				{
					Tag t = taglist.get(i);
					if(t.getTagname().equals(tag[j])){
						ifexist=true;
						break;
					}
					
				}
				if(!ifexist)
				{
					System.out.println(tag[j]);
					Tag newtag = new Tag();
					newtag.setTagname(tag[j]);
					hs.save(newtag);
				}
				//新建Tag标签
				
				
				FoodTagId foodtagid = new FoodTagId();
				foodtagid.setFoodid(id+1);
				foodtagid.setTagname(tag[j]);
				FoodTag foodtag = new FoodTag();
				foodtag.setId(foodtagid);
				
				hs.save(foodtag);
				//更新FoodTag
			}
		}
		
		hs.save(newfood);
		
		tran.commit();
		HibernateSessionFactory.closeSession();
	}
	
	static public Food GetOneFood(int foodid)
	{
		List<Food> list = QueryDB("from Food where foodid="+foodid);
		Food food = list.get(0);
		return food;
	}
	
	static public Restaurant GetOneRestaurant(String name)
	{
		List<Restaurant> restlist = QueryDB("from Restaurant where restaurantname='"+name+"'");
		Restaurant rest = restlist.get(0);
		return rest;
	}
	
	static public void ChangeLike(int foodid,int count)
	{
		Food food = GetOneFood(foodid);
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		food.setLikenumber(count);
		System.out.println(food.getFoodname());
		hs.saveOrUpdate(food);
		tran.commit();
		HibernateSessionFactory.closeSession();
	}
	
	static public void ChangeScore(int foodid,double score)
	{
		Food food = GetOneFood(foodid);
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		food.setScore(score);
		hs.saveOrUpdate(food);
		tran.commit();
		HibernateSessionFactory.closeSession();
	}
	
	static public void AddRestaurant(int restid,String name)
	{
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		
		Restaurant rest = new Restaurant();
		rest.setRestaurantid(restid);
		rest.setRestaurantname(name);
		hs.save(rest);
		
		tran.commit();
		hs.close();
	}
	
	static public void AddTelephone(String tel, int restid)
	{
		Session hs = HibernateSessionFactory.getSession();
		Transaction tran = hs.beginTransaction();
		
		Telephone telephone = new Telephone();
		telephone.setPhonenumber(tel);
		telephone.setRestaurantid(restid);
		hs.save(telephone);
		
		tran.commit();
		hs.close();
		
	}

	static public void PublishTelephone(String restaurant,String telephone)
	{
		List<Restaurant> restlist = QueryDB("from Restaurant");
		boolean ifexist=false;
		for(Restaurant rest:restlist)
		{
			if(rest.getRestaurantname().equals(restaurant))
			{
				List<Telephone> tellist = QueryDB("from Telephone");
				//System.out.println(rest.getRestaurantid());
				for(Telephone tel : tellist)
				{
					//System.out.println("tel--id:"+tel.getRestaurantid());
					if(tel.getRestaurantid().equals(rest.getRestaurantid()))
					{
						//System.out.println("==========");
						AddTelephone(telephone,rest.getRestaurantid());
					}
				}
				ifexist=true;
				break;
			}
		}
		if(!ifexist)
		{
			Restaurant newrest = new Restaurant();
			int id;
			if(restlist.size()!=0)
			{
				Restaurant lastrest = restlist.get(restlist.size()-1);
				id=lastrest.getRestaurantid()+1;
			}
			else
				id=1;
			AddRestaurant(id,restaurant);
			AddTelephone(telephone,id);
			
		}
	}
}
