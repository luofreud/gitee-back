import {useBaseApi} from '/@/api/base';

// 星座年运势接口服务
export const useXzYearfortunesApi = () => {
	const baseApi = useBaseApi("xzYearfortunes");
	return {
		// 分页查询星座年运势
		page: baseApi.page,
		// 查看星座年运势详细
		detail: baseApi.detail,
		// 新增星座年运势
		add: baseApi.add,
		// 更新星座年运势
		update: baseApi.update,
		// 删除星座年运势
		delete: baseApi.delete,
		// 批量删除星座年运势
		batchDelete: baseApi.batchDelete,
		// 导出星座年运势数据
		exportData: baseApi.exportData,
		// 导入星座年运势数据
		importData: baseApi.importData,
		// 下载星座年运势数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 星座年运势实体
export interface XzYearfortunes {
	// 主键Id
	id: number;
	// 运势时间
	ftime: string;
	// 星座类型
	signtype: number;
	// 综合分数
	allscore: number;
	// 爱情分数
	lovescore: number;
	// 健康分数
	healthscore: number;
	// 财富分数
	wealthscore: number;
	// 幸运数字
	luckynum: number;
	// 幸运颜色
	luckycolor: string;
	// 幸运花
	luckyflower: string;
	// 幸运石
	luckystone: string;
	// 解释
	explaincontent: string;
}