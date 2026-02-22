import pandas as pd
df = pd.read_excel(r'D:\python_learn\Online Retail.xlsx')

print(df.head())

print('\n数据行列数:')
print(df.info())

print('\n数据类型与空值:')
print(df.describe())

# 1.删除没有客户id的列
df = df.dropna(subset = ['CustomerID'])
# 2.去除退货.异常价格
df = df[(df['Quantity'] > 0) & (df['UnitPrice'] > 0)]
print('清洗后的数据:',df.shape) # 查看清洗后的数据行列

# 计算每笔订单金额
df['amount'] = df['Quantity'] * df['UnitPrice']
# 总销售额
total_sales = df['amount'].sum()
print('总销售额:',round(total_sales,2))
# 总客户数
customer_num = df['CustomerID'].nunique()
print('总客户数:',customer_num)

## 每月销售额趋势
import matplotlib.pyplot as plt
plt.rcParams['font.sans-serif'] = ['SimHei']
df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
df['year_month'] = df['InvoiceDate'].dt.to_period('M')
month_sales = df.groupby('year_month')['amount'].sum()
print(month_sales)
month_sales.plot(kind = 'line',title = '每月销售趋势',figsize = (10,6))
plt.show()

## 销量最高的10个国家
country_sales = df.groupby('Country')['amount'].sum().sort_values(ascending = False).head(10)
print(country_sales)
country_sales.plot(kind = 'bar' , title = '各国销量前10', figsize = (10,6))
plt.show()

## 最畅销的商品前10
goods_sales = df.groupby('Description')['amount'].sum().sort_values(ascending = False).head(10)
print(goods_sales)
goods_sales.plot(kind = 'bar' , title = '畅销商品前10', figsize = (10,6))
plt.show()