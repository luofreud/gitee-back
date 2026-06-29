import {useBaseApi} from '/@/api/base';

// 导师直播间接口服务
export const useXzTeachroomApi = () => {
	const baseApi = useBaseApi("xzTeachroom");
	return {
		// 分页查询导师直播间
		page: baseApi.page,
		// 查看导师直播间详细
		detail: baseApi.detail,
		// 新增导师直播间
		add: baseApi.add,
		// 更新导师直播间
		update: baseApi.update,
		// 删除导师直播间
		delete: baseApi.delete,
		// 批量删除导师直播间
		batchDelete: baseApi.batchDelete,
		// 导出导师直播间数据
		exportData: baseApi.exportData,
		// 导入导师直播间数据
		importData: baseApi.importData,
		// 下载导师直播间数据导入模板
		downloadTemplate: baseApi.downloadTemplate,
	}
}

// 导师直播间实体
export interface XzTeachroom {
	// 主键Id
	id: number;
	// 
	tid: number;
	// 直播间id
	roomid: number;
	// 直播间图片
	img: string;
	// 1：置顶
	istop: number;
	// 1：火热
	ishot: number;
	// 0：1v1,1:问答
	rtype: number;
	// 标题
	title: string;
	// 房间人数
	rnum: number;
	// 0：在线，1：连麦中，2：结束
	state: number;
	// 时间
	ceratetime: string;
	// 标签
	tags: string;
	// 结束时间
	overtime: string;
	// 直播时长
	livetime: number;
}