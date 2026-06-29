import {useBaseApi} from '/@/api/base';

// 用户签到接口服务
export const useXzCheckApi = () => {
	const baseApi = useBaseApi("xzCheck");
	return {
		// 分页查询用户签到
		page: baseApi.page,
		// 查看用户签到详细
		detail: baseApi.detail,
		// 新增用户签到
		add: baseApi.add,
		// 更新用户签到
		update: baseApi.update,
		// 删除用户签到
		delete: baseApi.delete,
		// 批量删除用户签到
		batchDelete: baseApi.batchDelete,
		// 导出用户签到数据
		exportData: baseApi.exportData,
		// 导入用户签到数据
		importData: baseApi.importData,
		// 下载用户签到数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 用户签到实体
export interface XzCheck {
	// 主键Id
	id: number;
	// uid
	uid: number;
	// 签到时间
	qdtime: string;
	// 记录时间
	createtime: string;
}