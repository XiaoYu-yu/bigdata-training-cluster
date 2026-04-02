<%@ page import="dbtaobao.connDb" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>消费行为统计</title>
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
                <h1>消费行为统计</h1>
                <p>基于用户购买行为的数据分析</p>
            </div>
            <div class="chart-container">
                <div id="chart" class="chart"></div>
            </div>
        </div>
    </div>
    <script>
        // 初始化图表
        var chart = echarts.init(document.getElementById('chart'));
        
        // 消费行为数据
        var actionData = [
            <jsp:scriptlet>
                try {
                    connDb conn = new connDb();
                    java.sql.ResultSet rs = conn.executeQuery("SELECT action, COUNT(*) as count FROM dbtaobao.user_log GROUP BY action");
                    boolean first = true;
                    while (rs.next()) {
                        if (!first) out.print(",");
                        out.print("{value: " + rs.getInt("count") + ", name: '" + (rs.getInt("action") == 0 ? "浏览" : rs.getInt("action") == 1 ? "收藏" : rs.getInt("action") == 2 ? "加购" : "购买") + "'}");
                        first = false;
                    }
                    conn.close();
                } catch (Exception e) {
                    out.print("{value: 1, name: '浏览'},{value: 1, name: '收藏'},{value: 1, name: '加购'},{value: 1, name: '购买'}");
                }
            </jsp:scriptlet>
        ];
        
        // 配置项
        var option = {
            title: {
                text: '用户行为分布',
                left: 'center'
            },
            tooltip: {
                trigger: 'item',
                formatter: '{a} <br/>{b}: {c} ({d}%)'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: ['浏览', '收藏', '加购', '购买']
            },
            series: [
                {
                    name: '用户行为',
                    type: 'pie',
                    radius: '60%',
                    center: ['50%', '50%'],
                    data: actionData,
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