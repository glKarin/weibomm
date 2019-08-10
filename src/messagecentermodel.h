#ifndef _KARIN_MESSAGECENTERMODEL_H
#define _KARIN_MESSAGECENTERMODEL_H

#include "pagedqmlmodel_base.h"
#include "id_std.h"

class id_messageCenterModel : public idPagedQmlModel_base
{
	Q_OBJECT

	public:
		enum idDataRole_e
		{
			Role_imageAddress = Qt::UserRole + 1,
			Role_isVip,
			Role_senderId,
			Role_dateInfo,
			Role_shortText,
		};

	public:
		virtual ~id_messageCenterModel();
		ID_SINGLE_INSTANCE_DEF(id_messageCenterModel)

			public Q_SLOTS:
			void deleteTheMessage(int index);
		QString getSenderNamebyIndex(int index) const;
		QString getSenderIdbyIndex(int index) const;
		QString getSenderImagebyIndex(int index) const;
		bool getVipbyIndex(int index) const;
		QString getSendTimebyIndex(int index) const;
		QString getContentbyIndex(int index);
		void getMessageInfo(int type = 0);
		void sendMessageContent(const QString &userId, const QString &content);

Q_SIGNALS:
			void sendMessageFinished(int errCode);
			void getMessageFinished(int errCode);
			void deleteMessageFinished(int errCode);

	protected:
		virtual void InitRoleMap();

	private:
		explicit id_messageCenterModel(QObject *parent = 0);
};

#endif
