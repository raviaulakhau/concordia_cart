package com.shashi.service;

import java.util.List;
import java.util.Map;

import com.shashi.beans.ProductBean;

public interface  DiscountService 
{
	
	public double suggestDiscountBasedOnCart(String username);
	public double suggestDiscountBasedOnSpending(String username);
	public Map<String, Integer> getProductSalesData();
}
