import {useBaseApi} from '/@/api/base';

// 系统标题栏目接口服务
export const useXzTitleitemApi = () => {
	const baseApi = useBaseApi("xzTitleitem");
	return {
		// 分页查询系统标题栏目
		page: baseApi.page,
		// 查看系统标题栏目详细
		detail: baseApi.detail,
		// 新增系统标题栏目
		add: baseApi.add,
		// 更新系统标题栏目
		update: baseApi.update,
		// 删除系统标题栏目
		delete: baseApi.delete,
		// 批量删除系统标题栏目
		batchDelete: baseApi.batchDelete,
		// 导出系统标题栏目数据
		exportData: baseApi.exportData,
		// 导入系统标题栏目数据
		importData: baseApi.importData,
		// 下载系统标题栏目数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 系统标题栏目实体
export interface XzTitleitem {
	// 主键Id
	id: number;
	// 标题名称
	name: string;
	// 逗号分隔
	img: string;
	// 跳转地址
	url: string;
	// 点击次数
	click: number;
	// 排序
	sortcode: number;
	// 时间
	createtime: string;
}