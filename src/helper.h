#ifndef _KARIN_HELPER_H
#define _KARIN_HELPER_H

#include <QString>

class idHelper
{
	public:
		static QString FixedContentEmotion(const QString &src);
		static void ShowBanner(const QString &text);

	private:
		explicit idHelper();
		virtual ~idHelper();
		Q_DISABLE_COPY(idHelper)
};

#endif
