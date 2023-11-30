package com.shashi.service;

import java.io.InputStream;
import java.util.List;

import com.shashi.beans.ProductBean;

public interface ProductService {

	public String addProduct(String prodName, String prodType, String prodInfo, double prodPrice, int prodQuantity,
			InputStream prodImage,double pRating,int used,double discount);

	public String addProduct(ProductBean product);

	public String removeProduct(String prodId);

	public String updateProduct(ProductBean prevProduct, ProductBean updatedProduct);

	public String updateProductPrice(String prodId, double updatedPrice);


	public List<ProductBean> searchAllProducts(String search);

	public byte[] getImage(String prodId);

	public ProductBean getProductDetails(String prodId);

	public String updateProductWithoutImage(String prevProductId, ProductBean updatedProduct);

	public double getProductPrice(String prodId);

	public boolean sellNProduct(String prodId, int n);

	public int getProductQuantity(String prodId);
	
	public List<ProductBean> getAllProducts();
	
	public List<ProductBean> getAllProducts(String sortOrder);
	
	public List<ProductBean> getProductLessThanThree();
	public List<ProductBean> getAllUsedProducts();
	public List<ProductBean> getAllProductsByType(String type);
	public List<ProductBean> getAllProductsOnSale();
}
