<%@ page import="dbtaobao.connDb" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品类别销量</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>数据可视化</h2>
            <ul>
                <li><a href="index.jsp">消费行为统计</a></li>
                <li><a href="index2.jsp">男女交易对比</a></li>
                <li><a href="index3.jsp">年龄分布对比</a></li>
                <li><a href="index4.jsp">商品类别销量</a></li>
                <li><a href="index5.jsp">省份成交量</a></li>
                <li><a href="index6.jsp">回头客预测</a></li>
            </ul>
        </div>
        <div class="main-content">
            <div class="header">
                <h1>商品类别销量</h1>
                <p>基于商品类别维度的销量分析</p>
            </div>
            <div class="chart-container">
                <div id="chart" class="chart"></div>
            </div>
        </div>
    </div>
    <script>
        // 初始化图表
        var chart = echarts.init(document.getElementById('chart'));
        
        // 商品类别数据
        var categoryData = [
            <jsp:scriptlet>
                try {
                    connDb conn = new connDb();
                    java.sql.ResultSet rs = conn.executeQuery("SELECT cat_id, COUNT(*) as count FROM dbtaobao.user_log WHERE action = 3 GROUP BY cat_id ORDER BY count DESC LIMIT 10");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) out.print(",");
                        out.print("{value: " + rs.getInt("count") + ", name: '类别 " + rs.getString("cat_id") + "'}");
                        first = false;
                    }
                    conn.close();
                } catch (Exception e) {
                    out.print("{value: 1, name: '类别 1'},{value: 1, name: '类别 2'},{value: 1, name: '类别 3'},{value: 1, name: '类别 4'},{value: 1, name: '类别 5'},{value: 1, name: '类别 6'},{value: 1, name: '类别 7'},{value: 1, name: '类别 8'},{value: 1, name: '类别 9'},{value: 1, name: '类别 10'}");
                }
            </jsp:scriptlet>
        ];
        
        // 配置项
        var option = {
            title: {
                text: '商品类别销量TOP10',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 'left'
            },
            series: [
                {
                    name: '销量',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '50%'],
                    data: categoryData,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };
        
        // 设置配置项
        chart.setOption(option);
        
        // 响应式处理
        window.addEventListener('resize', function() {
            chart.resize();
        });
    </script>
</body>
</html>